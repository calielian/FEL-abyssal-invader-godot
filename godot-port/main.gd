extends Node

@export var cena_inimigo: PackedScene
@export var cena_bala: PackedScene

var tipo_bala_selecionado := "Default"
var recursos_bala: Array[BalaBase]

var cooldown_default := false
var cooldown_shotgun := false
var cooldown_blast := false

func _ready() -> void:
	recursos_bala = [load("res://resources/bala_base.tres"), load("res://resources/bala_shotgun.tres"), load("res://resources/bala_blast.tres")]
	$CooldownDefault.wait_time = recursos_bala[0].tempo_espera
	$CooldownShotgun.wait_time = recursos_bala[1].tempo_espera
	$CooldownBlast.wait_time = recursos_bala[2].tempo_espera 

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	$Player.restart()
	get_tree().call_group("inimigo", "queue_free")

func _on_cooldown_default_timeout() -> void:
	cooldown_default = false

func _on_cooldown_shotgun_timeout() -> void:
	cooldown_shotgun = false

func _on_cooldown_blast_timeout() -> void:
	cooldown_blast = false
