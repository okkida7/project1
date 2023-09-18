extends Node2D

var label : Label
var timer : Timer

func _ready():
	label = $Label
	timer = $Timer
	# Start the timer. It will timeout after 5 seconds.
	timer.start()

	# Connect the timer's timeout signal to our function
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))


func _on_Timer_timeout():
	# Hide the label when the timer times out
	label.hide()
