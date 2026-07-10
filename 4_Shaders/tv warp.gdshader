shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// ---------------------------------------------
// Warp controls
// ---------------------------------------------
uniform float warpStrength : hint_range(0.0, 1.0) = 0.22;
uniform float warpAnisoX : hint_range(0.1, 3.0) = 1.0;
uniform float warpAnisoY : hint_range(0.1, 3.0) = 1.15;
uniform float edgeFade : hint_range(0.0, 0.25) = 0.06;

vec2 _crt_warp(vec2 uv) {
	vec2 p = uv * 2.0 - 1.0;

	vec2 aniso = vec2(warpAnisoX, warpAnisoY);
	p *= aniso;

	float r2 = dot(p, p);
	p *= (1.0 + warpStrength * r2);

	p /= aniso;
	return p * 0.5 + 0.5;
}

float _edge_fade(vec2 uv) {
	float fx = smoothstep(0.0, edgeFade, uv.x) * smoothstep(0.0, edgeFade, 1.0 - uv.x);
	float fy = smoothstep(0.0, edgeFade, uv.y) * smoothstep(0.0, edgeFade, 1.0 - uv.y);
	return fx * fy;
}

void fragment() {
	vec2 uv = SCREEN_UV;

	vec2 wuv = _crt_warp(uv);

	vec3 col = texture(SCREEN_TEXTURE, clamp(wuv, vec2(0.0), vec2(1.0))).rgb;

	float ef = _edge_fade(wuv);
	col *= ef;

	COLOR = vec4(col, 1.0);
}
