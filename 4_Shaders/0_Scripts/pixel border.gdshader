shader_type canvas_item;

uniform bool borderEnabled = true;
uniform vec4 borderColor : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float borderWidthPixels : hint_range(1.0, 16.0) = 1.0;

void fragment() {
	// COLOR initially contains the Sprite2D's modulate and self_modulate.
	vec4 spriteModulate = COLOR;
	vec4 textureColor = texture(TEXTURE, UV);

	// Apply modulate only to the original sprite.
	vec4 mainColor = textureColor * spriteModulate;

	float firstLayerAlpha = 0.0;
	float finalBorderAlpha = 0.0;

	if (borderEnabled) {
		for (int x = -16; x <= 16; x++) {
			for (int y = -16; y <= 16; y++) {
				vec2 pixelOffset = vec2(float(x), float(y));
				float squareDistance = max(
					abs(float(x)),
					abs(float(y))
				);

				if (squareDistance <= 1.0) {
					vec2 offset = pixelOffset * TEXTURE_PIXEL_SIZE;
					vec4 nearbyColor = texture(
						TEXTURE,
						UV + offset
					);

					firstLayerAlpha = max(
						firstLayerAlpha,
						nearbyColor.a
					);
				}
			}
		}

		for (int x = -16; x <= 16; x++) {
			for (int y = -16; y <= 16; y++) {
				vec2 pixelOffset = vec2(float(x), float(y));
				float circleDistance = length(pixelOffset);

				if (circleDistance <= borderWidthPixels) {
					vec2 offset = pixelOffset * TEXTURE_PIXEL_SIZE;
					float expandedAlpha = 0.0;

					for (int ix = -1; ix <= 1; ix++) {
						for (int iy = -1; iy <= 1; iy++) {
							vec2 innerOffset = vec2(
								float(ix),
								float(iy)
							) * TEXTURE_PIXEL_SIZE;

							vec4 nearbyColor = texture(
								TEXTURE,
								UV + offset + innerOffset
							);

							expandedAlpha = max(
								expandedAlpha,
								nearbyColor.a
							);
						}
					}

					finalBorderAlpha = max(
						finalBorderAlpha,
						expandedAlpha
					);
				}
			}
		}
	}

	vec4 finalColor = mainColor;

	// Use textureColor.a instead of mainColor.a so modulate does not
	// change which pixels are considered part of the outline.
	if (
		borderEnabled
		&& textureColor.a <= 0.0
		&& finalBorderAlpha > 0.0
	) {
		// Do not multiply this by spriteModulate.
		finalColor = borderColor;
	}

	COLOR = finalColor;
}