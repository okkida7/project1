extends RigidBody2D

var is_initial_instance

func _ready():
	get_parent().connect("slice_made", Callable(self, "_on_slice_made"))
	if is_initial_instance:
		gravity_scale *= Global.gravity_multiplier
		mass *= Global.mass_multiplier
		is_initial_instance = false

func _physics_process(delta):
	if position.y > 1000:
		pass
		#go_to_end_scene()

func slice(slicing_polygon):
	var original_polygon = $CollisionPolygon2D.polygon
	var offset_poly = self.global_transform * original_polygon
	
	var sliced_polygons = Geometry2D.clip_polygons(offset_poly, slicing_polygon)
	if sliced_polygons.size() == 2:
		

		var half1_points = sliced_polygons[0]
		var half2_points = sliced_polygons[1]

		# Create the new halves from the sliced polygons
		
		#visualize_polygon(half1_points)
		#visualize_polygon(half2_points)
		create_halves_from_points(half1_points, half2_points, slicing_polygon)
		queue_free()
		
	else:
		print("Slicing failed or was not clean.")

func visualize_polygon(poly_points: PackedVector2Array):
	var poly = Polygon2D.new()
	poly.polygon = poly_points
	poly.color = Color(randf(), randf(), randf()) # Gives it a random color for differentiation

	get_parent().add_child(poly)
	#queue_free()
	
func create_halves_from_points(half1_points: PackedVector2Array, half2_points: PackedVector2Array, slicing_polygon: PackedVector2Array):
	var bottom = self.duplicate()
	var top = self.duplicate()
	bottom.is_initial_instance = false
	top.is_initial_instance = false
	
	print("creating halves")
	
	bottom.get_node("CollisionPolygon2D").polygon = self.global_transform.affine_inverse() * half1_points 
	top.get_node("CollisionPolygon2D").polygon = self.global_transform.affine_inverse() * half2_points
	
	var bottom_bounds = get_y_bounds(half1_points)
	var top_bounds = get_y_bounds(half2_points)
	
	# Calculate heights
	var bottom_height = abs(bottom_bounds[1] - bottom_bounds[0])
	var top_height = abs(top_bounds[1] - top_bounds[0])
	
	print("height of bottom: ", bottom_height)
	print("height of top: ", top_height)
	
	# Adjust region for the top half (retain top part)
	var original_rect = top.get_node("Sprite2D").region_rect
	top.get_node("Sprite2D").region_enabled = true
	top.get_node("Sprite2D").region_rect = Rect2(original_rect.position, Vector2(original_rect.size.x, top_height))

	# Calculate the difference in height for the top sprite and adjust its position
	var top_difference = (original_rect.size.y - top_height) * 0.5
	top.get_node("Sprite2D").position.y -= top_difference

	# Adjust region for the bottom half (retain bottom part)
	original_rect = bottom.get_node("Sprite2D").region_rect
	var y_start_position = original_rect.size.y - bottom_height
	bottom.get_node("Sprite2D").region_enabled = true
	bottom.get_node("Sprite2D").region_rect = Rect2(Vector2(0, y_start_position), Vector2(original_rect.size.x, bottom_height))

	# Calculate the difference in height for the bottom sprite and adjust its position
	var bottom_difference = (original_rect.size.y - bottom_height) * 0.5
	bottom.get_node("Sprite2D").position.y += bottom_difference
	
	#top.freeze = true
	#bottom.freeze = true
	get_parent().add_child(top)
	get_parent().add_child(bottom)
	
	# For the bottom half (or half1 in your script)
	bottom.apply_central_impulse(Vector2(-50, 50))   # pushes the piece to the left
	bottom.apply_torque(1000)                # makes the piece spin clockwise
	
	#top.apply_central_impulse(Vector2(50, -200))   # pushes the piece to the left
	#top.apply_torque_impulse(1000)   
	
	

func get_y_bounds(points: PackedVector2Array) -> Array:
	var min_y = INF
	var max_y = -INF
	for point in points:
		if point.y < min_y:
			min_y = point.y
		if point.y > max_y:
			max_y = point.y
	return [min_y, max_y]
	
	



func go_to_new_scene():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
