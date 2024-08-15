extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	EventSystem.listen_to_event(self, "game_started")
	EventSystem.trigger_event("game_started")
	

func game_started(event_name: String, data: Dictionary):
	print("test")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
