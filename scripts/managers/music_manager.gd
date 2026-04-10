class_name MusicManager
extends AudioStreamPlayer

func _ready() -> void:
	Global.music_manager = self

func change_music(audio_name: String):
	if audio_name == "none":
		stop()
		self["parameters/switch_to_clip"] = null
	elif audio_name != self["parameters/switch_to_clip"]:
		play()
		self["parameters/switch_to_clip"] = audio_name
