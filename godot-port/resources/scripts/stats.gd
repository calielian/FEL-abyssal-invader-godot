class_name Stats
extends Resource

@export var vida := 1
@export var velocidade := 400

func clonar() -> Stats:
	var novo := Stats.new()
	novo.vida = self.vida
	novo.velocidade = self.velocidade
	return novo
