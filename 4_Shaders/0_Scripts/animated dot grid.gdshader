shader_type canvas_item;

uniform vec4 backgroundColor : source_color = vec4(0.02, 0.02, 0.05, 1.0);
uniform vec4 starColor : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float cellSize : hint_range(4.0, 64.0, 1.0) = 12.0;

// Chance a cell contains a star.
uniform float starDensity : hint_range(0.0, 1.0) = 0.22;

// Chance a star becomes a 2x2 star instead of 1x1.
uniform float largeStarChance : hint_range(0.0, 1.0) = 0.15;

uniform vec2 moveDirection = vec2(1.0, 1.0);
uniform float moveSpeed : hint_range(-100.0, 100.0) = 8.0;

float random(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
	vec2 pixelPos = SCREEN_UV / SCREEN_PIXEL_SIZE;

	vec2 dir = normalize(moveDirection);
	vec2 movement = dir * moveSpeed * TIME;

	vec2 world = pixelPos - movement;

	vec2 cell = floor(world / cellSize);
	vec2 local = mod(world, cellSize);

	float r = random(cell);

	float star = 0.0;

	if (r < starDensity) {
		float size = 1.0;

		if (random(cell + 53.0) < largeStarChance) {
			size = 2.0;
		}

		if (local.x < size && local.y < size) {
			star = 1.0;
		}
	}

	vec4 color = mix(backgroundColor, starColor, star);

	COLOR = color;
}