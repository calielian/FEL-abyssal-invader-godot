class_name Bala
extends RigidBody2D

@export var stats: BalaBase

func _ready() -> void:
	$Sprite2D.texture = stats.sprite
	$Sprite2D.scale = Vector2(stats.escala_textura, stats.escala_textura)
	$CollisionShape2D.scale = Vector2(stats.escala_hitbox, stats.escala_hitbox)
	linear_velocity = Vector2(0, -stats.velocidade)

func _process(_delta: float) -> void:
	if stats.perfuracao == 0:
		queue_free() 

func _on_body_entered(body: Node2D) -> void:
	if body is Inimigo:
		body.tomar_dano()
		stats.perfuracao -= 1

func _on_screen_exited() -> void:
	queue_free()

func get_tipo() -> String:
	return self.stats.tipo_bala
