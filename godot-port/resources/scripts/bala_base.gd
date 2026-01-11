class_name BalaBase
extends Resource

@export_enum("Default", "Shotgun", "Blast") var tipo_bala: String
@export var dano := 1
@export var perfuracao := 1
@export var velocidade := 1000
@export var tempo_espera := 0.5
@export var escala_textura := 0.13
@export var escala_hitbox := 0.5
@export var sprite: Texture2D = preload("res://images/bullets/bullet-default.png")

func clonar() -> BalaBase:
	var novo := BalaBase.new()

	novo.tipo_bala = self.tipo_bala
	novo.dano = self.dano
	novo.perfuracao = self.perfuracao
	novo.velocidade = self.velocidade
	novo.tempo_espera = self.tempo_espera
	novo.escala_textura = self.escala_textura
	novo.escala_hitbox = self.escala_hitbox
	novo.sprite = self.sprite
	
	return novo
