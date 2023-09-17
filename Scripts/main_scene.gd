extends Node2D

# preload the food scene
var Food = preload("res://Food.tscn")

func _ready():
	# spawn food at regular intervals
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_spawn_food")
	timer.wait_time = 1.0
	timer.start()

func _on_spawn_food():
	var food = Food.instance()
	food.position = Vector2(rand_range(100, 600), 0)
	add_child(food)
