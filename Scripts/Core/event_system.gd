# event_system.gd
extends Node

signal event_triggered(event_name: String, data: Dictionary)

# An array to store the log of events
var event_log: Array = []

# Log the event
func log_event(event_name: String, data: Dictionary):
	var log_entry = {
		"event_name": event_name,
		"data": data
	}
	event_log.append(log_entry)
	print("Event Logged: %s | Data: %s" % [event_name, data])

# Trigger an event and log it
func trigger_event(event_name: String, data: Dictionary = {}):
	log_event(event_name, data)
	emit_signal("event_triggered", event_name, data)

# Allow other objects to listen to events
func listen_to_event(target: Object, method: String):
	event_triggered.connect(Callable(target, method))

# Retrieve the event log
func get_event_log() -> Array:
	return event_log
