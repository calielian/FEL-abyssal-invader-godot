class_name Inimigo
extends Area2D

signal acerto(posicao: Vector2)
signal inimigo_morto

@export var stats: Stats
@export var sprites: Array[Texture2D]
@export var stats_bala: BalaBase = load("res://resources/bala_inimigo.tres")
@export var cena_bala: PackedScene

var local_stats: Stats
var estilo_movimento: estilos_movimento

var pausado := false
var cooldown_bala := false

var tempo := 0.0
var wave := 1

var esta_indo_direita := true
var tamanho_tela: Vector2

enum estilos_movimento {RETO, ONDULATORIO, RETO_TIRO, LADO}

func _ready() -> void:
	$Sprite2D.texture = sprites.pick_random()
	local_stats = stats.clonar()
	$AnimationPlayer.set("active", true)
	tamanho_tela = get_viewport_rect().size

func _process(delta: float) -> void:
	tempo += delta
	var velocidade = local_stats.velocidade + wave * 5
	
	match estilo_movimento:
		estilos_movimento.RETO:
			position.y += velocidade * delta

		estilos_movimento.ONDULATORIO:
			const frequencia := 3.0
			const amplitude := 1.0
			var direcao_movimento: float = sin(tempo * frequencia) * amplitude

			position.y += velocidade * delta
			position.x += direcao_movimento
			$Sprite2D.rotation = -atan2(direcao_movimento, 1)

		estilos_movimento.RETO_TIRO:
			position.y += velocidade * delta
			if not cooldown_bala: atirar()

		estilos_movimento.LADO:
			var direcao := 1

			direcao = 1 if esta_indo_direita else -1
			position.y += 100 * delta
			position.x += direcao

			if position.x == Vector2.ZERO.x or position.x >= tamanho_tela.x:
				esta_indo_direita = not esta_indo_direita
			
			if not cooldown_bala: atirar()

func _on_screen_exited() -> void:
	queue_free()

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
	if area is Bala and not area.inimiga:
		tomar_dano()
		area.perfurar()
		acerto.emit(area.position)

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

func atirar() -> void:
	var nova_bala: Bala = cena_bala.instantiate()
	nova_bala.stats = stats_bala.clonar()
	nova_bala.position = position
	nova_bala.rotate(PI)
	nova_bala.inimiga = true
	$CooldownBala.comecar()
	cooldown_bala = true
	
	for node in get_parent().get_children():
		if node is CanvasLayer:
			node.pausado.connect(nova_bala.alternar_pause)
			node.retomar.connect(nova_bala.alternar_pause)
		if node is Player:
			node.game_over.connect(nova_bala.alternar_pause)
		
	get_parent().add_child(nova_bala)

func _on_cooldown_bala_timeout() -> void:
	cooldown_bala = false

func alterar_tipo_movimento(tipo: estilos_movimento) -> void:
	self.estilo_movimento = tipo
	
	if self.estilo_movimento == estilos_movimento.RETO_TIRO:
		$CooldownBala.wait_time = 1.2
	elif  self.estilo_movimento == estilos_movimento.LADO:
		$CooldownBala.wait_time = 0.7
