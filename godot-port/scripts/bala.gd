extends RigidBody2D

signal acerto(dano: int)
@export var stats: BalaBase

func _ready() -> void:
	var velocidade := Vector2(0, stats.velocidade)
	
	linear_velocity = velocidade.rotated(-PI / 2)

func _process(_delta: float) -> void:
	if stats.perfuracao == 0:
		queue_free() 

func _on_body_entered(body: Node2D) -> void:
	if "inimigo" in body.get_groups():
		acerto.emit(stats.dano)
		stats.perfuracao -= 1
