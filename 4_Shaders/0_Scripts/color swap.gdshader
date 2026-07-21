shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// How many color pairs should be checked.
uniform int colorCount : hint_range(0, 20, 1) = 1;

group_uniforms OriginalColors;
// Colors to search for.
uniform vec4 originalBackgroundColor : source_color = vec4(1.0);
uniform vec4 originalBackground2Color : source_color = vec4(1.0);
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
uniform vec4 originalUIOne : source_color = vec4(1.0);
uniform vec4 originalUITwo : source_color = vec4(1.0);

group_uniforms ReplacementColors;
// Replacement colors.
uniform vec4 backgroundColor : source_color = vec4(1.0);
uniform vec4 background2Color : source_color = vec4(1.0);
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
uniform vec4 uiOne : source_color = vec4(1.0);
uniform vec4 uiTwo : source_color = vec4(1.0);

// Increase this if colors are not being detected.
uniform float tolerance : hint_range(0.0, 0.25, 0.001) = 0.01;

vec4 get_original_color(int index) {
	switch (index) {
		case 0:
			return originalBackgroundColor;
		case 1:
			return originalBackground2Color;
		case 2:
			return originalTextColor;
			
		case 3:
			return originalPrimaryPlayerOneColor;
		case 4:
			return originalBasePlayerOneColor;
		case 5:
			return originalDarkPlayerOneColor;
		case 6:
			return originalDarkerPlayerOneColor;
		case 7:
			return originalShinePlayerOneColor;
			
		case 8:
			return originalPrimaryPlayerTwoColor;
		case 9:
			return originalBasePlayerTwoColor;
		case 10:
			return originalDarkPlayerTwoColor;
		case 11:
			return originalDarkerPlayerTwoColor;
		case 12:
			return originalShinePlayerTwoColor;
			
		case 13:
			return originalSecondaryPlayerColor;
		case 14:
			return originalUIOne;
		case 15:
			return originalUITwo;
	}

	return vec4(0.0);
}

vec4 get_replacement_color(int index) {
	switch (index) {
		case 0:
			return backgroundColor;
		case 1:
			return background2Color;
		case 2:
			return textColor;
			
		case 3:
			return primaryPlayerOneColor;
		case 4:
			return primaryBasePlayerOneColor;
		case 5:
			return primaryDarkPlayerOneColor;
		case 6:
			return primaryDarkerPlayerOneColor;
		case 7:
			return primaryShinePlayerOneColor;
			
		case 8:
			return primaryPlayerTwoColor;
		case 9:
			return primaryBasePlayerTwoColor;
		case 10:
			return primaryDarkPlayerTwoColor;
		case 11:
			return primaryDarkerPlayerTwoColor;
		case 12:
			return primaryShinePlayerTwoColor;
			
		case 13:
			return secondaryPlayerColor;
		case 14:
			return uiOne;
		case 15:
			return uiTwo;
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