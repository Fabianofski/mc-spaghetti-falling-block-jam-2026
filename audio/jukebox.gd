extends AudioStreamPlayer2D

@onready var winning_sound: AudioStreamPlayer2D = $WinningSound
@onready var loosing_sound: AudioStreamPlayer2D = $LoosingSound

func _ready() -> void:
	SignalBus.game_state_change.connect(_change_music)
	loosing_sound.finished.connect(on_sound_finished)
	winning_sound.finished.connect(on_sound_finished)
	
	_change_music()

func _change_music(state: String = "menu"):
	match state:
		"menu":
			stream.set_sync_stream_volume(0, -60.0)
			stream.set_sync_stream_volume(1, 0.0)
		"gameplay":
			stream.set_sync_stream_volume(0, 0.0)
			stream.set_sync_stream_volume(1, -60.0)
		"day_failed":
			stream.set_sync_stream_volume(0, -60.0)
			stream.set_sync_stream_volume(1, -60.0)
			loosing_sound.play()
		"day_success":
			stream.set_sync_stream_volume(0, -60.0)
			stream.set_sync_stream_volume(1, -60.0)
			winning_sound.play()
			

func on_sound_finished():
	var _fade_tween = create_tween()
	_fade_tween.tween_method(
		func(val: float): stream.set_sync_stream_volume(0, val),
		-60,
		0,
		1
	)
