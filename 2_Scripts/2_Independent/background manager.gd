extends Control

@export_category("References")
@export var noise : FastNoiseLite
@export_category("Settings")
@export var noiseSpeed : float = 2.5

func _process(delta: float) -> void:
	return
	_animate_noise(delta, noise)

func _animate_noise(delta : float, noiseToMove : FastNoiseLite):
	noiseToMove.offset.z += noiseSpeed * delta
