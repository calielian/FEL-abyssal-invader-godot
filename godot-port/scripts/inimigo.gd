extends Area2D

signal acerto(posicao: Vector2)
signal inimigo_morto()

@export var stats: Stats
@export var sprites: Array[Texture2D]
var local_stats: Stats

var pausado := false

func _ready() -> void:
	$Sprite2D.texture = sprites.pick_random()
	local_stats = stats.clonar()
	$AnimationPlayer.set("active", true)

func _process(delta: float) -> void:
	position.y += stats.velocidade * delta

func _on_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Bala:
		tomar_dano()
		body.perfurar()
		acerto.emit(body.position)

func tomar_dano():
	self.local_stats.vida -= 1
	
	if self.local_stats.vida == 0:
		inimigo_morto.emit()
		queue_free()
		return

	$FrameInvencibilidade.comecar()
	$AnimationPlayer.play("piscar")
	$CollisionShape2D.set_deferred("disabled", true)

func set_vida(nova_vida: int):
	local_stats.vida = nova_vida

func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		area.tomar_dano()

func alternar_pause() -> void:
	set_process(not is_processing())
	pausado = not pausado
	if not pausado and $AnimationPlayer.is_playing():
		$FrameInvencibilidade.pausar()
		$AnimationPlayer.pause()
	elif $FrameInvencibilidade.esta_pausado():
		$FrameInvencibilidade.despausar()
		$AnimationPlayer.play("piscar")

func _on_frame_invencibilidade_timeout() -> void:
	$CollisionShape2D.disabled = false
