extends RigidBody2D

func _ready():
	get_parent().connect("slice_made", Callable(self, "_on_slice_made"))
	gravity_scale *= Global.gravity_multiplier
	mass *= Global.mass_multiplier

func _physics_process(delta):
	if position.y > 1000:
		go_to_end_scene()

func slice(slicing_polygon):
	var original_polygon = $CollisionPolygon2D.polygon
	var offset_poly = self.global_transform * original_polygon
	
	var sliced_polygons = Geometry2D.clip_polygons(offset_poly, slicing_polygon)
	if sliced_polygons.size() == 2:
		queue_free()
		go_to_new_scene()
		Global.increase_gravity_multiplier(1.5)
		Global.increase_mass_multiplier(1.5)

func go_to_new_scene():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
	
func go_to_end_scene():
	get_tree().change_scene_to_file("res://Scenes/end_menu.tscn")
