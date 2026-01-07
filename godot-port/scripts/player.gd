class_name Player
extends Area2D

signal game_over

@export var stats: Stats

var tamanho_tela: Vector2

func _ready() -> void:
	tamanho_tela = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocidade_vt := Vector2.ZERO
	var direcao: float = Input.get_axis("mover_esquerda", "mover_direita")

	velocidade_vt.x += direcao

	if velocidade_vt.length() > 0:
		velocidade_vt = velocidade_vt.normalized() * stats.velocidade

	position += velocidade_vt * delta
	position = position.clamp(Vector2.ZERO, tamanho_tela)

func tomar_dano() -> void:
	stats.vida -= 1

	if stats.vida == 0:
		game_over.emit()
		queue_free()

	$CollisionShape2D.set_deferred("disabled", true)
	$FrameInvencibilidade.start()
	
	for i in randi_range(0, 5):
		show()
		await get_tree().create_timer(0.5).timeout
		hide()

func _on_frame_invencibilidade_timeout() -> void:
	$CollisionShape2D.disabled = false
