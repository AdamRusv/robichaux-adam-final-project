shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// How many color pairs should be checked.
uniform int colorCount : hint_range(0, 20, 1) = 1;

group_uniforms OriginalColors;
// Colors to search for.
uniform vec4 originalOutlineColor : source_color = vec4(1.0);
uniform vec4 originalTextColor : source_color = vec4(1.0);
uniform vec4 originalPrimaryPlayerOneColor : source_color = vec4(1.0);
uniform vec4 originalBasePlayerOneColor : source_color = vec4(1.0);
uniform vec4 originalDarkPlayerOneColor : source_color = vec4(1.0);
uniform vec4 originalDarkerPlayerOneColor : source_color = vec4(1.0);
uniform vec4 originalShinePlayerOneColor : source_color = vec4(1.0);
uniform vec4 originalPrimaryPlayerTwoColor : source_color = vec4(1.0);
uniform vec4 originalBasePlayerTwoColor : source_color = vec4(1.0);
uniform vec4 originalDarkPlayerTwoColor : source_color = vec4(1.0);
uniform vec4 originalDarkerPlayerTwoColor : source_color = vec4(1.0);
uniform vec4 originalShinePlayerTwoColor : source_color = vec4(1.0);
uniform vec4 originalSecondaryPlayerColor : source_color = vec4(1.0);
uniform vec4 originalBackgroundOne : source_color = vec4(1.0);
uniform vec4 originalBackgroundTwo : source_color = vec4(1.0);

group_uniforms ReplacementColors;
// Replacement colors.
uniform vec4 outlineColor : source_color = vec4(1.0);
uniform vec4 textColor : source_color = vec4(1.0);
uniform vec4 primaryPlayerOneColor : source_color = vec4(1.0);
uniform vec4 primaryBasePlayerOneColor : source_color = vec4(1.0);
uniform vec4 primaryDarkPlayerOneColor : source_color = vec4(1.0);
uniform vec4 primaryDarkerPlayerOneColor : source_color = vec4(1.0);
uniform vec4 primaryShinePlayerOneColor : source_color = vec4(1.0);
uniform vec4 primaryPlayerTwoColor : source_color = vec4(1.0);
uniform vec4 primaryBasePlayerTwoColor : source_color = vec4(1.0);
uniform vec4 primaryDarkPlayerTwoColor : source_color = vec4(1.0);
uniform vec4 primaryDarkerPlayerTwoColor : source_color = vec4(1.0);
uniform vec4 primaryShinePlayerTwoColor : source_color = vec4(1.0);
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
			return originalBasePlayerOneColor;
		case 4:
			return originalDarkPlayerOneColor;
		case 5:
			return originalDarkerPlayerOneColor;
		case 6:
			return originalShinePlayerOneColor;
			
		case 7:
			return originalPrimaryPlayerTwoColor;
		case 8:
			return originalBasePlayerTwoColor;
		case 9:
			return originalDarkPlayerTwoColor;
		case 10:
			return originalDarkerPlayerTwoColor;
		case 11:
			return originalShinePlayerTwoColor;
			
		case 12:
			return originalSecondaryPlayerColor;
		case 13:
			return originalBackgroundOne;
		case 14:
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
			return primaryBasePlayerOneColor;
		case 4:
			return primaryDarkPlayerOneColor;
		case 5:
			return primaryDarkerPlayerOneColor;
		case 6:
			return primaryShinePlayerOneColor;
			
		case 7:
			return primaryPlayerTwoColor;
		case 8:
			return primaryBasePlayerTwoColor;
		case 9:
			return primaryDarkPlayerTwoColor;
		case 10:
			return primaryDarkerPlayerTwoColor;
		case 11:
			return primaryShinePlayerTwoColor;
			
		case 12:
			return secondaryPlayerColor;
		case 13:
			return backgroundOne;
		case 14:
			return backgroundTwo;
	}

	return vec4(0.0);
}

void fragment() {
	vec4 screenColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 finalColor = screenColor;

	for (int i = 0; i < colorCount; i++) {
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