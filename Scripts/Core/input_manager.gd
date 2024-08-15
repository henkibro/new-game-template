# input_manager.gd
extends Node

signal action_pressed(action_name: String)
signal action_released(action_name: String)
signal action_just_pressed(action_name: String)
signal action_just_released(action_name: String)

# Dictionary to hold custom input mappings if needed
var custom_actions: Dictionary = {}

func _ready() -> void:
	# Optionally, you can load custom input actions from a configuration file here
	# Or add custom actions directly
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		for action_name in InputMap.get_actions():
			if Input.is_action_pressed(action_name):
				emit_signal("action_pressed", action_name)
			if Input.is_action_just_pressed(action_name):
				emit_signal("action_just_pressed", action_name)
			if Input.is_action_just_released(action_name):
				emit_signal("action_just_released", action_name)
			if not Input.is_action_pressed(action_name) and event.is_pressed():
				emit_signal("action_released", action_name)

func listen_to_action(action_name: String, target: Object, pressed_method: String = "", released_method: String = "", just_pressed_method: String = "", just_released_method: String = "") -> void:
	if pressed_method != "":
		action_pressed.connect(Callable(target, pressed_method))
	if released_method != "":
		action_released.connect(Callable(target, released_method))
	if just_pressed_method != "":
		action_just_pressed.connect(Callable(target, just_pressed_method))
	if just_released_method != "":
		action_just_released.connect(Callable(target, just_released_method))

func add_custom_action(action_name: String, events: Array) -> void:
	InputMap.add_action(action_name)
	for event in events:
		InputMap.action_add_event(action_name, event)
	custom_actions[action_name] = events

func remove_custom_action(action_name: String) -> void:
	if InputMap.has_action(action_name):
		InputMap.erase_action(action_name)
		custom_actions.erase(action_name)
