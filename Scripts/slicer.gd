# Create the script file for the slicing logic

extends Node

signal slice_made(from, to)

func _input(event):
	if event is InputEventScreenDrag:
		emit_signal("slice_made", event.position - event.relative, event.position)
