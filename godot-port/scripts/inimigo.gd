class_name Inimigo
extends RigidBody2D

@export var stats: Stats
@export var sprites: Array[Texture2D]

func _ready() -> void:
	$Sprite2D.texture = sprites.pick_random()

func _on_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.tomar_dano()
	elif body is Bala:
		tomar_dano()

func tomar_dano():
	stats.vida -= 1
	
	if stats.vida == 0:
		queue_free()

func set_vida(nova_vida: int):
	stats.vida = nova_vida
