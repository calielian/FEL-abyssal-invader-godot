extends Area2D

signal retirar_vida(quantidade: int)

@export var velocidade := 400
@export var qtd_vida := 3

var tamanho_tela: Vector2

func _ready() -> void:
	tamanho_tela = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocidade_vt := Vector2.ZERO
	var direcao: float = Input.get_axis("mover_esquerda", "mover_direita")

	velocidade_vt.x += direcao

	if velocidade_vt.length() > 0:
		velocidade_vt = velocidade_vt.normalized() * velocidade

	position += velocidade_vt * delta
	position = position.clamp(Vector2.ZERO, tamanho_tela)

func _on_body_entered(_body: Node2D) -> void:
	qtd_vida -= 1
	retirar_vida.emit(qtd_vida)
	$CollisionShape2D.set_deferred("disabled", true)
	$FrameInvencibilidade.start()

func _on_frame_invencibilidade_timeout() -> void:
	$CollisionShape2D.disabled = false
