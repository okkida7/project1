extends RigidBody2D

var vertical_level =  true


func slice(slicer_start, slicer_end):
	print("called slice on pizza")
	var results = get_intersection_point(slicer_start, slicer_end)
	var intersections = results["intersections"]
	var segments = results["segments"]
	if intersections.size() > 1:
		var halves = create_halves_from_intersections(
			$CollisionPolygon2D.polygon,
			$CollisionPolygon2D.to_local(intersections[0]),
			$CollisionPolygon2D.to_local(intersections[1]),
			[$CollisionPolygon2D.to_local(segments[0][0]), $CollisionPolygon2D.to_local(segments[0][1])],
			[$CollisionPolygon2D.to_local(segments[1][0]), $CollisionPolygon2D.to_local(segments[1][1])]
		)

	
func get_intersection_point(slicer_start, slicer_end):
	# Logic to calculate the intersection point between the slicing line and this object's shape.
	
	var intersections = []
	var segments = []  # This will store the segments on which intersections were found
	
	var polygon_points = $CollisionPolygon2D.polygon

	for i in range(polygon_points.size()):
		
		var start_point = $CollisionPolygon2D.global_transform * polygon_points[i]
		var end_point = $CollisionPolygon2D.global_transform * polygon_points[(i + 1) % polygon_points.size()]
		var intersection = Geometry2D.segment_intersects_segment(start_point, end_point, slicer_start, slicer_end)
		if intersection:
			print('intersection found at ', intersection)

			intersections.append(intersection)
			segments.append([start_point, end_point])
			
	for intersection in intersections:
		var local_intersection = $CollisionPolygon2D.to_local(intersection)
		var debug_point = load("res://debugpoint.tscn").instantiate()
		debug_point.position  = local_intersection
		self.add_child(debug_point)
		
	return {"intersections": intersections, "segments": segments}
	

	
func create_halves_from_intersections(points: Array, intersection1: Vector2, intersection2: Vector2, seg1_points: Array, seg2_points: Array) -> Array:
	var top_half = [intersection1]
	var bottom_half = [intersection1]
	
	
	var current_point
	var current_point_b
	
	print("points: ", points)
	print("intersection point 1: ", intersection1)
	print("intersection point 2: ", intersection2)
	print("seg1_points: " , seg1_points)
	print("seg2_points: ",  seg2_points)
	
	# Find the next point for the top half
	if seg1_points[0].y < seg1_points[1].y:
		current_point = seg1_points[0]
		current_point_b = seg1_points[1]
	else:
		current_point = seg1_points[1]
		current_point_b = seg1_points[0]
		
	top_half.append(current_point)
	
	# Determine the direction
	var idx = points.find(current_point)
	var left_point = points[(idx - 1 + points.size()) % points.size()]
	var right_point = points[(idx + 1) % points.size()]
	var direction = 1 if left_point.y > right_point.y else -1

	# Traverse through the points for the top half
	while not (current_point in seg2_points):
		idx = (idx + direction) % points.size()
		current_point = points[idx]
		top_half.append(current_point)
		#print("top half points...: ", top_half)

	# Close the top half with the second intersection point
	top_half.append(intersection2)
	
	print("top half points: ", top_half)
	
	
	# Find the next point for the bottom half
	bottom_half.append(current_point_b)

	# Determine the direction for bottom half
	var direction_b = -direction
	var idx_b = points.find(current_point_b)
	
	# Traverse through the points for the bottom half
	while not (current_point_b in seg2_points):
		idx_b = (idx_b + direction_b) % points.size()
		current_point_b = points[idx_b]
		bottom_half.append(current_point_b)

	# Close the bottom half with the second intersection point
	bottom_half.append(intersection2)
	
	var halves = spawn_halves_and_delete_original(top_half, bottom_half)
	
	return halves
	
	
func spawn_halves_and_delete_original(top_half_points: Array, bottom_half_points: Array):
	# Duplicate the original for top half
	var top_half = self.duplicate()
	top_half.get_node("CollisionPolygon2D").polygon = top_half_points
	get_parent().add_child(top_half)
	top_half.global_position = self.global_position   # Ensure it spawns at the correct position

	# Duplicate the original for bottom half
	var bottom_half = self.duplicate()
	bottom_half.get_node("CollisionPolygon2D").polygon = bottom_half_points
	get_parent().add_child(bottom_half)
	bottom_half.global_position = self.global_position  # Ensure it spawns at the correct position
	
	
	# Queue the original object for deletion
	self.queue_free()
	
	return [top_half, bottom_half]
