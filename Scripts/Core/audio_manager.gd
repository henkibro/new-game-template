extends Node

var master_volume: float = 1.0
var bgm_volume: float = 1.0
var sfx_volume: float = 1.0

func set_master_volume(value: float) -> void:
	master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func set_bgm_volume(value: float) -> void:
	bgm_volume = value
	_apply_bgm_volume()

func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	_apply_sfx_volume()

func _apply_bgm_volume() -> void:
	for bgm_player in get_tree().get_nodes_in_group("BGMPlayers"):
		bgm_player.volume_db = linear_to_db(bgm_volume)

func _apply_sfx_volume() -> void:
	for sfx_player in get_tree().get_nodes_in_group("SFXPlayers"):
		sfx_player.volume_db = linear_to_db(sfx_volume)

func _set_volume(name: String, value: float) -> void:
	match name:
		"master":
			set_master_volume(value)
		"bgm":
			set_bgm_volume(value)
		"sfx":
			set_sfx_volume(value)

func update_volumes() -> void:
	_set_volume("master", master_volume)
	_set_volume("bgm", bgm_volume)
	_set_volume("sfx", sfx_volume)

func play_bgm(audio_stream: AudioStream, volume: float) -> void:
	var bgm_player = AudioStreamPlayer.new()
	bgm_player.stream = audio_stream
	bgm_player.volume_db = linear_to_db(volume)
	bgm_player.play()
	get_tree().root.add_child(bgm_player)
	bgm_player.finished.connect(bgm_player.queue_free)  # Using the recommended connect method
	bgm_player.add_to_group("BGMPlayers")

func play_sfx(audio_stream: AudioStream, volume: float) -> void:
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = audio_stream
	sfx_player.volume_db = linear_to_db(volume)
	sfx_player.play()
	get_tree().root.add_child(sfx_player)
	sfx_player.finished.connect(sfx_player.queue_free)  # Using the recommended connect method
	sfx_player.add_to_group("SFXPlayers")

func stop_all_sounds() -> void:
	for audio_player in get_tree().root.get_children():
		if audio_player is AudioStreamPlayer:
			audio_player.stop()
