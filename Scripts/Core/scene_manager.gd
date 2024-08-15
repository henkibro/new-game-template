# scene_manager.gd
extends Node

signal scene_changed(new_scene: Node)

# The currently active scene
var current_scene: Node = null

# For fade transitions (optional)
@export var transition_time: float = 0.5
@export var fade_color: Color = Color.BLACK

func _ready() -> void:
	# Optionally, you can preload and set the initial scene here
	pass

func change_scene(scene_path: String, with_transition: bool = true) -> void:
	var new_scene = load(scene_path)
	
	if with_transition:
		_fade_out()
		await get_tree().create_timer(transition_time).timeout
	
	_replace_scene(new_scene.instantiate())

	if with_transition:
		await _fade_in()

	emit_signal("scene_changed", current_scene)

func _replace_scene(new_scene: Node) -> void:
	if current_scene:
		remove_child(current_scene)
		current_scene.queue_free()
	
	current_scene = new_scene
	add_child(current_scene)
	get_tree().current_scene = current_scene

func _fade_out() -> void:
	var fade_rect = _create_fade_rect()
	add_child(fade_rect)
	fade_rect.modulate.a = 0
	fade_rect.create_tween().tween_property(fade_rect, "modulate:a", 1.0, transition_time)

func _fade_in() -> void:
	var fade_rect = _create_fade_rect()
	fade_rect.modulate.a = 1
	add_child(fade_rect)
	var tween = fade_rect.create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, transition_time)
	await tween.finished
	fade_rect.queue_free()

func _create_fade_rect() -> ColorRect:
	var fade_rect = ColorRect.new()
	fade_rect.color = fade_color
	fade_rect.anchor_top = 0
	fade_rect.anchor_bottom = 1
	fade_rect.anchor_left = 0
	fade_rect.anchor_right = 1
	fade_rect.size_flags_horizontal = Control.SIZE_FILL
	fade_rect.size_flags_vertical = Control.SIZE_FILL
	return fade_rect
