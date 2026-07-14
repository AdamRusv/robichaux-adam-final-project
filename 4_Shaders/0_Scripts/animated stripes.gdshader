shader_type canvas_item;

uniform vec4 lineColor : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float lineAmount : hint_range(1.0, 64.0, 1.0) = 12.0;
uniform float lineThickness : hint_range(0.0, 1.0, 0.01) = 0.12;
uniform float lineSpeed = 0.5;

uniform float diagonalAngle = 1.0;

// Number of pixel blocks across the ColorRect.
// Lower values create larger pixels.
uniform vec2 pixelResolution = vec2(160.0, 90.0);

void fragment() {
	// Snap the visual pattern to the custom pixel grid.
	vec2 pixelatedUV =
		floor(UV * pixelResolution)
		/ pixelResolution;

	vec4 backgroundColor = COLOR;

	float diagonalValue =
		pixelatedUV.x * diagonalAngle
		+ pixelatedUV.y;

	// Amount the stripe phase changes when moving by one vertical pixel.
	float movementStep =
		lineAmount
		/ pixelResolution.y;

	// Preserve the original speed, but restrict movement to pixel-sized steps.
	float smoothPixelMovement =
		floor((TIME * lineSpeed) / movementStep)
		* movementStep;

	float movingLines = fract(
		diagonalValue * lineAmount
		+ smoothPixelMovement
	);

	float lineMask = step(
		movingLines,
		lineThickness
	);

	vec3 finalRgb = mix(
		backgroundColor.rgb,
		lineColor.rgb,
		lineMask * lineColor.a
	);

	COLOR = vec4(
		finalRgb,
		backgroundColor.a
	);
}