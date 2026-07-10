shader_type canvas_item;

/* ── Screen sampler (Godot 4.x syntax, mipmaps enabled) ── */
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

/* ── Toggles ── */
uniform bool enableVignette		= true;
uniform bool enableBloom		= true;
uniform bool enableGrain		= true;
uniform bool enableChromAb		= true;
uniform bool enableColorGrade	= true;

/* ── Vignette ── */
uniform float vignetteRadius	: hint_range(0.0, 1.5) = 1.05;	// >1 pushes corners darker
uniform float vignetteSoftness	: hint_range(0.0, 1.0) = 0.45;
uniform float vignetteStrength	: hint_range(0.0, 1.0) = 0.22;

/* ── Bloom (uses mip levels of screen) ── */
uniform float bloomStrength		: hint_range(0.0, 1.0) = 0.2;
uniform float bloomMipLevel		: hint_range(0.0, 6.0) = 3.5;	// higher = blurrier (depends on RT size)

/* ── Film grain ── */
uniform float grainAmount		: hint_range(0.0, 0.5) = 0.035;
uniform float grainSpeed		: hint_range(0.0, 10.0) = 1.5;
uniform float grainScale		: hint_range(0.5, 8.0) = 1.75;	// lower = finer grain

/* ── Chromatic aberration ── */
uniform float abAmount			: hint_range(0.0, 4.0) = 0.65;	// in pixels at screen edge

/* ── Simple color grading (lift / gamma / gain) ── */
uniform vec3 lift				= vec3(0.02, 0.01, 0.03);		// shadows
uniform vec3 gamma				= vec3(1.0, 1.0, 1.0);			// midtones (1.0 = neutral)
uniform vec3 gain				= vec3(1.04, 1.02, 1.05);		// highlights

/* ── Helpers ── */
float hash21(vec2 p) {
	// Simple hash for grain (stable and cheap)
	p = fract(p * vec2(123.34, 345.45));
	p += dot(p, p + 34.345);
	return fract(p.x * p.y);
}

vec3 apply_lift_gamma_gain(vec3 c, vec3 L, vec3 G, vec3 A) {
	// Clamp to avoid NANs on pow
	c = clamp(c + L, 0.0, 1.0);
	// Gamma: pow per channel (avoid 0 by max with tiny epsilon)
	c = pow(max(c, vec3(1e-4)), 1.0 / max(G, vec3(1e-4)));
	c *= A;
	return c;
}

void fragment() {
	// Base sample
	vec2 uv = SCREEN_UV;
	vec4 src = texture(SCREEN_TEXTURE, uv);

	// === Chromatic aberration (subtle) ===
	vec3 col = src.rgb;
	if (enableChromAb && abAmount > 0.0) {
		// Convert abAmount in pixels → UV units using TEXTURE_PIXEL_SIZE (vec2)
		vec2 px = TEXTURE_PIXEL_SIZE;
		// radial direction from center
		vec2 dc = uv - vec2(0.5, 0.5);
		float dist = length(dc);
		vec2 dir = dist > 0.0 ? dc / dist : vec2(0.0, 0.0);
		// scale shift with distance to edges
		float shift_px = abAmount * dist;						// pixels
		vec2 shift_uv = dir * shift_px * px;					// to UV
		float lod0 = 0.0;

		float r  = textureLod(SCREEN_TEXTURE, uv + shift_uv, lod0).r;
		float g  = textureLod(SCREEN_TEXTURE, uv,           lod0).g;
		float b  = textureLod(SCREEN_TEXTURE, uv - shift_uv, lod0).b;
		col = vec3(r, g, b);
	}

	// === Bloom via lower mip level ===
	if (enableBloom && bloomStrength > 0.0) {
		vec3 blur = textureLod(SCREEN_TEXTURE, uv, bloomMipLevel).rgb;
		// soft additive bloom, tempered by highlight energy from src
		float energy = clamp(max(max(src.r, src.g), src.b), 0.0, 1.0);
		col = mix(col, col + blur * energy, bloomStrength);
	}

	// === Color grading (lift/gamma/gain) ===
	if (enableColorGrade) {
		col = apply_lift_gamma_gain(col, lift, gamma, gain);
	}

	// === Vignette ===
	if (enableVignette && vignetteStrength > 0.0) {
		// distance from center normalized to fit aspect
		vec2 centered = (uv - vec2(0.5, 0.5));
		// correct for aspect ratio
		float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;	// width / height in pixels
		centered.x *= aspect;
		float d = length(centered);
		// smooth falloff
		float inner = vignetteRadius * (1.0 - vignetteSoftness);
		float outer = vignetteRadius;
		float v = smoothstep(inner, outer, d);
		col *= (1.0 - vignetteStrength * v);
	}

		// === Film grain (erratic, long-run stable) ===
	if (enableGrain && grainAmount > 0.0) {
		// Pixel-ish space: consistent grain size across resolutions
		vec2 px = uv * vec2(1.0 / TEXTURE_PIXEL_SIZE.x, 1.0 / TEXTURE_PIXEL_SIZE.y) / grainScale;

		// Keep time bounded and decorrelated
		float tBase = float(TIME);
		float tWrap = fract(tBase * 0.163f);        // wrap time to [0,1) to avoid large magnitudes
		float tJit  = sin(tBase * 2.418f) * 0.5f + 0.5f; // smoothly changing jitter in [0,1]

		// Random tiny rotation per-frame-ish to avoid directional drift
		float ang = (tJit * 6.2831853f);            // 0..2π
		float ca = cos(ang), sa = sin(ang);
		mat2 R = mat2(vec2(ca, -sa), vec2(sa, ca));

		// Two differently-seeded samples mixed to break correlation
		vec2 p0 = R * (px + vec2(tWrap * grainSpeed, tWrap * 0.37f));
		vec2 p1 = R * (px * 0.73f + vec2(tJit * 3.1f, tJit * -2.7f));

		float n0 = hash21(p0);
		float n1 = hash21(p1 + vec2(17.0f, -43.0f));
		float n  = mix(n0, n1, 0.5f + 0.5f * sin(tBase * 1.7f)); // time-varying mix

		float g = (n - 0.5f) * 2.0f; // [-1,1]

		// Luma-preserving mask (grain weaker in deep shadows/highlights)
		float luma = dot(col, vec3(0.299f, 0.587f, 0.114f));
		float mask = smoothstep(0.08f, 0.5f, luma) * (1.0f - smoothstep(0.5f, 0.92f, luma));

		col += g * grainAmount * (0.35f + 0.65f * mask);
	}


	// Output (preserve original alpha)
	COLOR = vec4(col, src.a);
}
