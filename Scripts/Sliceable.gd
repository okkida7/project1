extends RigidBody2D

var velocity = Vector2(0, 100)
var speed_multiplier = 1.5

func _ready():
	get_parent().connect("slice_made", Callable(self, "_on_slice_made"))
	velocity.y *= speed_multiplier

func _physics_process(delta):
	position += velocity * delta

func slice(slicing_polygon):
	var original_polygon = $CollisionPolygon2D.polygon
	var offset_poly = self.global_transform * original_polygon
	
	var sliced_polygons = Geometry2D.clip_polygons(offset_poly, slicing_polygon)
	if sliced_polygons.size() == 2:
		#create_halves_from_points(half1_points, half2_points, slicing_polygon)
		queue_free()
		go_to_new_scene()
	else:
		print("Slicing failed or was not clean.")

func go_to_new_scene():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
	
	
