shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// How many screen pixels between scanlines (2.0 = every other row)
uniform float pixelsPerLine : hint_range(1.0, 8.0) = 2.0;

// Darkening amount
uniform float lineStrength : hint_range(0.0, 1.0) = 0.25;

// Higher = thinner/darker line core
uniform float lineSharpness : hint_range(0.1, 8.0) = 2.5;

// Optional motion, in pixels per second
uniform float scrollSpeedPxPerSec : hint_range(-200.0, 200.0) = 0.0;

// Darken based on brightness (keeps hue more stable)
uniform bool affectBrightnessOnly = true;

void fragment() {
	vec4 base = texture(SCREEN_TEXTURE, SCREEN_UV);

	// Convert to screen pixel coordinates so it's resolution/window-size consistent
	vec2 screenPx = SCREEN_UV / SCREEN_PIXEL_SIZE;

	// Phase in "lines", not UV
	float phase = (screenPx.y / max(pixelsPerLine, 0.0001)) + (TIME * (scrollSpeedPxPerSec / max(pixelsPerLine, 0.0001)));

	// 0..1 sine wave
	float s = 0.5 + 0.5 * sin(phase * 6.28318530718);

	// Shape to make darker, thinner lines
	float shaped = pow(s, lineSharpness);

	// Invert so the "line" is the dark part
	float dark = (1.0 - shaped) * lineStrength;

	if (affectBrightnessOnly) {
		float luma = dot(base.rgb, vec3(0.299, 0.587, 0.114));
		vec3 rgb = base.rgb - dark * luma;
		COLOR = vec4(max(rgb, vec3(0.0)), base.a);
	} else {
		COLOR = vec4(base.rgb * (1.0 - dark), base.a);
	}
}
