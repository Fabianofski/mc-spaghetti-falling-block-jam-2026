extends AudioStreamPlayer2D

func _ready() -> void:
	SignalBus.game_state_change.connect(_change_music)
	_change_music()

func _change_music(state: String = "menu"):
	match state:
		"menu":
			stream.set_sync_stream_volume(0, -60.0)
			stream.set_sync_stream_volume(1, 0.0)
		"gameplay":
			stream.set_sync_stream_volume(0, 0.0)
			stream.set_sync_stream_volume(1, -60.0)
