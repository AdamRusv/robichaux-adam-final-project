shader_type canvas_item;

// ===== Shadow =====
uniform float shadowAlphaPercent : hint_range(0.0, 100.0) = 70.0;
uniform vec2 shadowOffsetPx = vec2(2.0, 2.0);
uniform bool useTextureAlpha = true;

// ===== Glow =====
uniform bool glowEnabled = true;
uniform float glowAlphaPercent : hint_range(0.0, 100.0) = 60.0;
uniform float glowRadiusPx : hint_range(0.0, 8.0) = 2.0;
uniform vec4 glowColor : source_color = vec4(1.0, 1.0, 1.0, 1.0);

const vec2 GDIR[8] = vec2[](
	vec2( 1.0,  0.0), vec2(-1.0,  0.0),
	vec2( 0.0,  1.0), vec2( 0.0, -1.0),
	vec2( 1.0,  1.0), vec2(-1.0,  1.0),
	vec2( 1.0, -1.0), vec2(-1.0, -1.0)
);

void fragment() {
	// === Node/Material modulate ===
	vec4 modulateColor = COLOR;

	vec2 texel = TEXTURE_PIXEL_SIZE;

	// --- Shadow ---
	vec2 shadowUV = UV + shadowOffsetPx * texel;
	vec4 shadowSample = texture(TEXTURE, shadowUV);
	float baseA = useTextureAlpha ? shadowSample.a : 1.0;
	float shadowA = baseA * (shadowAlphaPercent / 100.0);
	vec4 shadow = vec4(0.0, 0.0, 0.0, shadowA);

	// --- Sprite (modulated) ---
	vec4 sprite = texture(TEXTURE, UV) * modulateColor;

	// --- Composite (shadow behind sprite) ---
	float outA = sprite.a + shadow.a * (1.0 - sprite.a);
	vec3 outRGB = shadow.rgb * shadow.a * (1.0 - sprite.a) + sprite.rgb * sprite.a;
	if (outA > 0.0) outRGB /= outA;

	// --- Glow (additive light; respects alpha modulate) ---
	if (glowEnabled) {
		float g = texture(TEXTURE, UV).a * 0.5;
		vec2 ring = texel * glowRadiusPx;
		for (int i = 0; i < 8; i++) {
			g += texture(TEXTURE, UV + GDIR[i] * ring).a;
		}
		g /= (0.5 + 8.0);
		float glowAmt = g * (glowAlphaPercent / 100.0) * modulateColor.a;
		outRGB += glowColor.rgb * glowAmt;
	}

	COLOR = vec4(outRGB, outA);
}
