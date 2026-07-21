shader_type canvas_item;

uniform vec4 backgroundColor : source_color = vec4(0.02, 0.02, 0.05, 1.0);
uniform vec4 starColor : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float cellSize : hint_range(4.0, 64.0, 1.0) = 12.0;
uniform float starDensity : hint_range(0.0, 1.0) = 0.22;
uniform float largeStarChance : hint_range(0.0, 1.0) = 0.15;
uniform float positionRandomness : hint_range(0.0, 1.0) = 0.85;

uniform vec2 moveDirection = vec2(1.0, -1.0);
uniform float moveSpeed : hint_range(-100.0, 100.0) = 8.0;


float random(vec2 p) {
	return fract(
		sin(dot(p, vec2(127.1, 311.7)))
		* 43758.5453123
	);
}

vec2 random2(vec2 p) {
	return vec2(
		random(p + vec2(17.3, 41.7)),
		random(p + vec2(83.1, 12.8))
	);
}

void fragment() {
	vec2 pixelPos = SCREEN_UV / SCREEN_PIXEL_SIZE;

	vec2 dir = moveDirection;

	if (length(dir) > 0.0) {
		dir = normalize(dir);
	}

	// Smooth, straight movement along the chosen direction.
	vec2 movement = dir * moveSpeed * TIME;
	vec2 world = pixelPos - movement;

	vec2 cell = floor(world / cellSize);
	vec2 local = mod(world, cellSize);

	float star = 0.0;

	if (random(cell) < starDensity) {
		float size = 1.0;

		if (random(cell + vec2(53.0)) < largeStarChance) {
			size = 2.0;
		}

		float availableSpace = max(cellSize - size, 0.0);

		vec2 centeredPosition = vec2(availableSpace * 0.5);
		vec2 scatteredPosition = random2(cell) * availableSpace;

		// Whole-pixel starting positions prevent stair-step movement.
		vec2 starPosition = floor(
			mix(
				centeredPosition,
				scatteredPosition,
				positionRandomness
			)
		);

		if (
			local.x >= starPosition.x
			&& local.y >= starPosition.y
			&& local.x < starPosition.x + size
			&& local.y < starPosition.y + size
		) {
			star = 1.0;
		}
	}

	COLOR = mix(backgroundColor, starColor, star);
}