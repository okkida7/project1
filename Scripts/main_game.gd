extends Node

var food_prefabs = ['res://Prefabs/hotdog.tscn', 'res://Prefabs/pizza.tscn', 'res://Prefabs/slice.tscn']
var spawn_position = Vector2(250, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_random_food()

func spawn_random_food():
	# Randomly select a food prefab path
	var random_path = food_prefabs[randi() % food_prefabs.size()]

	# Load the food prefab scene
	var food_scene = load(random_path)

	# Instance the food
	var food_instance = food_scene.instantiate()

	# Set its position
	food_instance.global_position = spawn_position
	food_instance.is_initial_instance = true

	# Add it to the current scene
	self.add_child(food_instance)
