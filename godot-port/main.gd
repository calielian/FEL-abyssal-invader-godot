extends Node

@export var cena_inimigo: PackedScene
@export var cena_bala: PackedScene
@export var cena_explosao: PackedScene

var tipo_bala_selecionado := "Default"
var recursos_bala: Array[BalaBase]

var cooldown_default := false
var cooldown_shotgun := false
var cooldown_blast := false

var tempo := 0

func _ready() -> void:
	recursos_bala = [load("res://resources/bala_base.tres"), load("res://resources/bala_shotgun.tres"), load("res://resources/bala_blast.tres")]
	$CooldownDefault.wait_time = recursos_bala[0].tempo_espera
	$CooldownShotgun.wait_time = recursos_bala[1].tempo_espera
	$CooldownBlast.wait_time = recursos_bala[2].tempo_espera
	novo_jogo()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("atirar"):
		if not cooldown_default: 
			var nova_bala: RigidBody2D = cena_bala.instantiate()
			nova_bala.stats = recursos_bala[0]
			nova_bala.position = $Player.position
			$CooldownDefault.start()
			cooldown_default = true 
		
			add_child(nova_bala)

func novo_jogo():
	$UI.desenhar_vidas(3)
	$Player.restart()
	get_tree().call_group("inimigo", "queue_free")

func _on_cooldown_default_timeout() -> void:
	cooldown_default = false

func _on_cooldown_shotgun_timeout() -> void:
	cooldown_shotgun = false

func _on_cooldown_blast_timeout() -> void:
	cooldown_blast = false

func _on_cooldown_spawn_timeout() -> void:
	var novo_inimigo: Area2D = cena_inimigo.instantiate()
	var localizacao_spawn = $PathSpawn/SpawnLocations
	
	localizacao_spawn.progress_ratio = randf()
	novo_inimigo.position = localizacao_spawn.position
	novo_inimigo.acerto.connect(_on_inimigo_acerto)
	
	add_child(novo_inimigo)

func _on_contagem_timeout() -> void:
	tempo += 1
	$UI.alterar_tempo(tempo)

func _on_player_vida_perdida() -> void:
	var explosao: AnimatedSprite2D = cena_explosao.instantiate()
	explosao.position = $Player.position
	add_child(explosao)

func _on_inimigo_acerto(posicao: Vector2) -> void:
	var explosao: AnimatedSprite2D = cena_explosao.instantiate()
	explosao.position = posicao
	add_child(explosao)
