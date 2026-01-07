class_name BalaBase
extends Resource

@export_enum("Default", "Shotgun", "Blast") var tipo_bala: String
@export var dano := 1
@export var perfuracao := 1
@export var velocidade := 1000
@export var tempo_espera := 1.0
@export var escala_textura := 0.13
@export var escala_hitbox := 0.5
@export var sprite: Texture2D = preload("res://images/bullets/bullet-default.png")
