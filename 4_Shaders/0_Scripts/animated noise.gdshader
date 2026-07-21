shader_type canvas_item;

uniform highp float move_speed = 7.0;
uniform highp float shape_size = 2.5;

uniform highp vec4 colour_1 : source_color = vec4(0.871, 0.267, 0.231, 1.0);
uniform highp vec4 colour_2 : source_color = vec4(0.0, 0.42, 0.706, 1.0);


vec4 effect(vec2 screen_size, vec2 screen_coords) {
	highp vec2 uv = (
		screen_coords
		- 0.5 * screen_size
	) / length(screen_size);
	uv *= 12.0;

	highp float movement = TIME * move_speed;
	highp vec2 uv2 = vec2(uv.x + uv.y);

	for (int i = 0; i < 3; i++) {
		uv2 += sin(max(uv.x, uv.y)) + uv;

		uv += 0.35 * vec2(
			cos(
				5.1123314
				+ 0.353 * uv2.y
				+ movement * 0.131121
			),
			sin(
				uv2.x
				- 0.113 * movement
			)
		);

		uv -= 0.35 * (
			cos(uv.x + uv.y)
			- sin(uv.x * 0.711 - uv.y)
		);
	}

	highp vec2 shape_uv = uv / shape_size;

	highp float horizontal_shapes = cos(
		shape_uv.x * 2.0
		+ movement * 0.025
	);

	highp float vertical_shapes = cos(
		shape_uv.y * 2.0
		- movement * 0.018
	);

	highp float diagonal_shapes = sin(
		(shape_uv.x + shape_uv.y) * 1.25
		+ movement * 0.012
	);

	highp float shape_value =
		horizontal_shapes
		+ vertical_shapes
		+ diagonal_shapes * 0.45;

	highp float colour_mask = step(0.25, shape_value);

	return mix(
		colour_2,
		colour_1,
		colour_mask
	);
}


void fragment() {
	COLOR *= effect(TEXTURE_PIXEL_SIZE, UV);
}