class_name Player
extends Area2D

signal game_over
signal vida_perdida

@export var stats: Stats
var stats_backup: Stats

var tamanho_tela: Vector2

func _ready() -> void:
	tamanho_tela = get_viewport_rect().size
	stats_backup = stats.clonar()

func _process(delta: float) -> void:
	var velocidade_vt := Vector2.ZERO
	var direcao: float = Input.get_axis("mover_esquerda", "mover_direita")

	velocidade_vt.x += direcao

	if velocidade_vt.length() > 0:
		velocidade_vt = velocidade_vt.normalized() * stats.velocidade

	position += velocidade_vt * delta
	position = position.clamp(Vector2.ZERO, tamanho_tela)

func tomar_dano() -> void:
	vida_perdida.emit()
	stats.vida -= 1

	if stats.vida == 0:
		game_over.emit()
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		return

	$CollisionShape2D.set_deferred("disabled", true)
	$FrameInvencibilidade.start()
	$AnimationPlayer.play("piscar")

func _on_frame_invencibilidade_timeout() -> void:
	$CollisionShape2D.disabled = false

func restart():
	position.x = tamanho_tela.x / 2
	stats = stats_backup.clonar()
