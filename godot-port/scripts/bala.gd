class_name Bala
extends Area2D

@export var stats: BalaBase
var inimiga := false
var direcao := 0

var local_perfuracao: int

func _ready() -> void:
	$Sprite2D.texture = stats.sprite
	print(stats.tipo_bala)
	$Sprite2D.scale = Vector2(stats.escala_textura, stats.escala_textura)
	$CollisionShape2D.scale = Vector2(stats.escala_hitbox, stats.escala_hitbox)
	self.local_perfuracao = stats.perfuracao

func _process(delta: float) -> void:
	if not stats.tipo_bala == "Shotgun":
		
		position.y += -stats.velocidade * delta
	else:
		print("verdadeiro")
		position.y += -stats.velocidade * delta
		position.x += ((stats.velocidade / 3) * direcao) * delta

	if self.local_perfuracao == 0:
		queue_free() 

func _on_screen_exited() -> void:
	queue_free()

func get_tipo() -> String:
	return self.stats.tipo_bala

func perfurar() -> void:
	self.local_perfuracao -= 1

func alternar_pause() -> void:
	set_process(not is_processing())

func _on_area_entered(area: Area2D) -> void:
	if area is Player and inimiga:
		area.tomar_dano()
