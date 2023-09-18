extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: PhysicsBody2D):
	# Check if the body is sliceable
	if body.is_in_group("sliceable"):
		# Delete the sliceable object
		body.queue_free()

	# Check if all sliceable objects are gone
	print(get_tree().get_nodes_in_group("sliceable"))
	if get_tree().get_nodes_in_group("sliceable").size() == 1:
		if Global.num_levels < Global.max_levels:
			_load_next_level()
			Global.num_levels += 1
		else: 
			go_to_end_scene()
		
func _load_next_level():
	print("num levels played: ", Global.num_levels)
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
	Global.gravity_multiplier += 1
	Global.mass_multiplier += 1

func go_to_end_scene():
	get_tree().change_scene_to_file("res://Scenes/end_menu.tscn")
