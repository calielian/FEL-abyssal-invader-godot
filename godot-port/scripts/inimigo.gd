extends Area2D

signal acerto(posicao: Vector2)

@export var stats: Stats
@export var sprites: Array[Texture2D]
var local_stats: Stats

func _ready() -> void:
	$Sprite2D.texture = sprites.pick_random()
	local_stats = stats.clonar()

func _process(delta: float) -> void:
	position.y += stats.velocidade * delta

func _on_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Bala:
		tomar_dano()
		acerto.emit(body.position)

func tomar_dano():
	self.local_stats.vida -= 1
	
	if local_stats.vida == 0:
		queue_free()

func set_vida(nova_vida: int):
	local_stats.vida = nova_vida

func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		area.tomar_dano()
