extends Control

class_name OneShotParticle

@export_category("References")
@export var sameTiming : Array[GPUParticles2D]

func _trigger_sameTiming():
	for particle in sameTiming:
		particle.restart()
		particle.emitting = true
