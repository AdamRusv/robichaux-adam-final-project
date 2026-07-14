shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// How many color pairs should be checked.
uniform int colorCount : hint_range(0, 7, 1) = 1;

group_uniforms OriginalColors;
// Colors to search for.
uniform vec4 originalOutlineColor : source_color = vec4(1.0);
uniform vec4 originalTextColor : source_color = vec4(1.0);
uniform vec4 originalPrimaryPlayerOneColor : source_color = vec4(1.0);
uniform vec4 originalPrimaryPlayerTwoColor : source_color = vec4(1.0);
uniform vec4 originalSecondaryPlayerColor : source_color = vec4(1.0);
uniform vec4 originalBackgroundOne : source_color = vec4(1.0);
uniform vec4 originalBackgroundTwo : source_color = vec4(1.0);

group_uniforms ReplacementColors;
// Replacement colors.
uniform vec4 outlineColor : source_color = vec4(1.0);
uniform vec4 textColor : source_color = vec4(1.0);
uniform vec4 primaryPlayerOneColor : source_color = vec4(1.0);
uniform vec4 primaryPlayerTwoColor : source_color = vec4(1.0);
uniform vec4 secondaryPlayerColor : source_color = vec4(1.0);
uniform vec4 backgroundOne : source_color = vec4(1.0);
uniform vec4 backgroundTwo : source_color = vec4(1.0);

// Increase this if colors are not being detected.
uniform float tolerance : hint_range(0.0, 0.25, 0.001) = 0.01;

vec4 get_original_color(int index) {
	switch (index) {
		case 0:
			return originalOutlineColor;
		case 1:
			return originalTextColor;
		case 2:
			return originalPrimaryPlayerOneColor;
		case 3:
			return originalPrimaryPlayerTwoColor;
		case 4:
			return originalSecondaryPlayerColor;
		case 5:
			return originalBackgroundOne;
		case 6:
			return originalBackgroundTwo;
	}

	return vec4(0.0);
}

vec4 get_replacement_color(int index) {
	switch (index) {
		case 0:
			return outlineColor;
		case 1:
			return textColor;
		case 2:
			return primaryPlayerOneColor;
		case 3:
			return primaryPlayerTwoColor;
		case 4:
			return secondaryPlayerColor;
		case 5:
			return backgroundOne;
		case 6:
			return backgroundTwo;
	}

	return vec4(0.0);
}

void fragment() {
	vec4 screenColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 finalColor = screenColor;

	for (int i = 0; i < 7; i++) {
		if (i >= colorCount) {
			break;
		}

		vec4 originalColor = get_original_color(i);

		float colorDifference = distance(
			screenColor.rgb,
			originalColor.rgb
		);

		if (colorDifference <= tolerance) {
			finalColor.rgb = get_replacement_color(i).rgb;
			break;
		}
	}

	finalColor.a = screenColor.a;
	COLOR = finalColor;
}