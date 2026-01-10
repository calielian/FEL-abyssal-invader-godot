extends Node

@export var cena_inimigo: PackedScene
@export var cena_bala: PackedScene
@export var cena_explosao: PackedScene

@onready var timers: Array[TimerPausavel] = [$CooldownDefault, $CooldownShotgun, $CooldownBlast, $CooldownSpawn, $Contagem]

var tipo_bala_selecionado := "Default"
var recursos_bala: Array[BalaBase]

var cooldown_default := false
var cooldown_shotgun := false
var cooldown_blast := false

var tempo := 0
var score := 0
var high_score := 0
var iniciado := false

var wave := 1

const CONFIG := "user://score.cfg"

func _ready() -> void:
	recursos_bala = [load("res://resources/bala_base.tres"), load("res://resources/bala_shotgun.tres"), load("res://resources/bala_blast.tres")]
	$CooldownDefault.wait_time = recursos_bala[0].tempo_espera
	$CooldownShotgun.wait_time = recursos_bala[1].tempo_espera
	$CooldownBlast.wait_time = recursos_bala[2].tempo_espera
	
	var config := ConfigFile.new()
	
	if config.load(CONFIG) != OK:
		config.set_value("player", "high_score", 0)
		config.save(CONFIG)
		return
	
	high_score = config.get_value("player", "high_score")

func _process(_delta: float) -> void:
	$UI.atualizar_pontuacao(score, high_score)
	if Input.is_action_pressed("atirar") and iniciado:
		if not cooldown_default: 
			var nova_bala: Bala = cena_bala.instantiate()
			nova_bala.stats = recursos_bala[0]
			nova_bala.position = $Player.position
			$CooldownDefault.comecar()
			cooldown_default = true
			$UI.pausado.connect(nova_bala.pausar)
			$UI.retomar.connect(nova_bala.despausar)
			$Player.game_over.connect(nova_bala.pausar)
		
			add_child(nova_bala)
	
	if Input.is_action_pressed("pausar") and iniciado:
		$UI.pause()
		iniciado = false

		for timer: TimerPausavel in timers:
			timer.pausar()

func novo_jogo():
	if $Player.its_over: $Background.alternar_pausado()
	$Player.restart()
	$CooldownSpawn.comecar()
	$Contagem.comecar()
	iniciado = true
	get_tree().call_group("inimigo", "queue_free")
	get_tree().call_group("bala", "queue_free")

func _on_cooldown_default_timeout() -> void:
	cooldown_default = false

func _on_cooldown_shotgun_timeout() -> void:
	cooldown_shotgun = false

func _on_cooldown_blast_timeout() -> void:
	cooldown_blast = false

func _on_cooldown_spawn_timeout() -> void:
	var novo_inimigo: Area2D = cena_inimigo.instantiate()
	var localizacao_spawn := $PathSpawn/SpawnLocations
	
	localizacao_spawn.progress_ratio = randf()
	novo_inimigo.position = localizacao_spawn.position
	novo_inimigo.acerto.connect(_on_inimigo_acerto)
	novo_inimigo.inimigo_morto.connect(_on_inimigo_morto)
	$UI.pausado.connect(novo_inimigo.alternar_pause)
	$UI.retomar.connect(novo_inimigo.alternar_pause)
	
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

func _on_inimigo_morto() -> void:
	score += 10
	
	if score >= high_score:
		high_score = score

func _on_ui_retomar() -> void:
	iniciado = true

	for timer: TimerPausavel in timers:
		timer.despausar()

func _on_ui_nova_wave() -> void:
	wave += 1
	$UI.alterar_wave(wave)
