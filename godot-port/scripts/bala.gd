class_name Bala
extends RigidBody2D

@export var stats: BalaBase

var local_perfuracao: int

func _ready() -> void:
	$Sprite2D.texture = stats.sprite
	$Sprite2D.scale = Vector2(stats.escala_textura, stats.escala_textura)
	$CollisionShape2D.scale = Vector2(stats.escala_hitbox, stats.escala_hitbox)
	linear_velocity = Vector2(0, -stats.velocidade)
	self.local_perfuracao = stats.perfuracao

func _process(_delta: float) -> void:
	if stats.perfuracao == 0:
		queue_free() 

func _on_screen_exited() -> void:
	queue_free()

func get_tipo() -> String:
	return self.stats.tipo_bala

func perfurar() -> void:
	self.local_perfuracao -= 1

func pausar() -> void:
	linear_velocity = Vector2.ZERO

func despausar() -> void:
	linear_velocity = Vector2(0, -stats.velocidade)
