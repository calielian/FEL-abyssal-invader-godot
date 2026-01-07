extends Node2D

# Configuração visível no Inspector
@export var velocidade: float = 200.0  # Negativo para cima, positivo para baixo
@onready var altura_maxima: float = 1198.0  # Altura TOTAL da sua textura
# 1198

func _ready():
	# Posiciona os sprites um abaixo do outro no início
	$Cima.position = Vector2(0, altura_maxima)  # "Bottom" começa logo ABAIXO do "Top"

func _process(delta):
	# Move AMBOS os sprites juntos (movendo o nó pai)
	position.y += velocidade * delta

	# Lógica de "wrapping": quando um sprite sai totalmente da tela por CIMA
	if position.y >= altura_maxima:
		# "Reposiciona" o nó pai para baixo, criando o loop contínuo
		position.y -= altura_maxima
