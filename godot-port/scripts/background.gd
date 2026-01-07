extends Node2D

@export var velocidade: float = 200.0
var altura_maxima: float = 1198.0

func _ready():
	$Cima.position = Vector2(0, altura_maxima)

func _process(delta):
	position.y += velocidade * delta

	if position.y >= altura_maxima:
		position.y -= altura_maxima
