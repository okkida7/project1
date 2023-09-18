extends RigidBody2D

var vertical_level =  true
var top_slice_shader_material = preload("res://Materials/bottomhalfmaterial.tres").duplicate()
var bottom_slice_shader_material = preload("res://Materials/tophalfmaterial.tres").duplicate()


func slice(slicing_polygon):
	print("called slice on pizza")
	var original_polygon = $CollisionPolygon2D.polygon
	var offset_poly = self.global_transform * original_polygon
	
	var sliced_polygons = Geometry2D.clip_polygons(offset_poly, slicing_polygon)
	if sliced_polygons.size() == 2:
		var half1_points = sliced_polygons[0]
		var half2_points = sliced_polygons[1]

		# Create the new halves from the sliced polygons
		
		visualize_polygon(half1_points)
		visualize_polygon(half2_points)
		#create_halves_from_points(half1_points, half2_points, slicing_polygon)
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
	var half1 = self.duplicate()
	var half2 = self.duplicate()
	
	print(half1.get_node("Sprite2D"))
	
	
	var slice_start = slicing_polygon[0] # define this based on your slicing logic
	var slice_end = slicing_polygon[3]   # define this based on your slicing logic

	# Pass the slice coordinates to the shaders
	top_slice_shader_material.set_shader_parameter("slice_start", slice_start)
	top_slice_shader_material.set_shader_parameter("slice_end", slice_end)
	
	bottom_slice_shader_material.set_shader_parameter("slice_start", slice_start)
	bottom_slice_shader_material.set_shader_parameter("slice_end", slice_end)
	# Adjusting position slightly for visualization
	half1.position += Vector2(-5, 0)
	half2.position += Vector2(5, 0)
	
	half1.get_node("Sprite2D").material = top_slice_shader_material
	half2.get_node("Sprite2D").material = bottom_slice_shader_material
	
	
	half1.get_node("CollisionPolygon2D").polygon = self.global_transform.affine_inverse() * half1_points 
	half2.get_node("CollisionPolygon2D").polygon = self.global_transform.affine_inverse() * half2_points
	
	get_parent().add_child(half1)
	get_parent().add_child(half2)
	
	

	# You might want to delete the original after a short delay
	# to prevent potential issues with script execution.
	#queue_free()
	
	
