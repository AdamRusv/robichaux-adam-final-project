shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

uniform vec4 targetColor : source_color = vec4(1.0);
uniform vec4 shadowColor : source_color = vec4(0.0, 0.0, 0.0, 0.75);
uniform float colorTolerance : hint_range(0.0, 1.0) = 0.01;

const vec2 GAME_RESOLUTION = vec2(320.0, 180.0);

void fragment() {
	vec4 currentColor = textureLod(
		SCREEN_TEXTURE,
		SCREEN_UV,
		0.0
	);
	
	if (currentColor == vec4(0, 0, 0, 1)){
		COLOR = vec4(0);
	}
	else{

	vec2 gamePixelSize = vec2(
		1.0 / GAME_RESOLUTION.x,
		1.0 / GAME_RESOLUTION.y
	);

	vec2 aboveUV = SCREEN_UV - vec2(
		0.0,
		gamePixelSize.y
	);

	vec4 aboveColor = textureLod(
		SCREEN_TEXTURE,
		aboveUV,
		0.0
	);

	float aboveDifference = distance(
		aboveColor.rgb,
		targetColor.rgb
	);

	float currentDifference = distance(
		currentColor.rgb,
		targetColor.rgb
	);

	float aboveMatches = 1.0 - step(
		colorTolerance,
		aboveDifference
	);

	float currentMatches = 1.0 - step(
		colorTolerance,
		currentDifference
	);

	float shadowMask = aboveMatches * (1.0 - currentMatches);

	vec4 finalColor = mix(
		currentColor,
		vec4(shadowColor.rgb, currentColor.a),
		shadowMask * shadowColor.a
	);

	COLOR = finalColor;
}}