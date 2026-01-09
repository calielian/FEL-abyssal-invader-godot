class_name TimerPausavel
extends Timer

var _tempo_restante_ao_pausar: float = 0.0
var _pausado: bool = false
var wait_time_backup: float

func pausar():
	if not _pausado and not is_stopped():
		_tempo_restante_ao_pausar = time_left
		stop()
		_pausado = true

func despausar():
	if _pausado:
		wait_time = _tempo_restante_ao_pausar
		start()
		_pausado = false

func esta_pausado() -> bool:
	return _pausado

func comecar(time_sec: float = -1.0):
	_pausado = false
	_tempo_restante_ao_pausar = 0.0
	wait_time_backup = wait_time
	timeout.connect(_reset)
	super.start(time_sec)

func _reset() -> void:
	wait_time = wait_time_backup
