extends Line2D

@onready var slicer_start = get_point_position(0)
@onready var slicer_end = get_point_position(1)

@onready var rectangle_points = create_rectangle_from_line(slicer_start, slicer_end, 2.0)
var intersecting_body: Node = null

var slice_possible = false


func _process(delta):
	if Input.is_action_just_pressed("Slice"):
		$AnimationPlayer.play('slice_animation')
		print("trying to slice")
		print(get_tree().get_nodes_in_group("sliceable"))
		# Check for any sliceable object intersections with the slicer line
		check_for_intersections()

func check_for_intersections():
	var sliceables = get_tree().get_nodes_in_group("sliceable")
	for sliceable in sliceables:
		var sliceable_polygon = sliceable.global_transform * sliceable.get_node("CollisionPolygon2D").polygon

		if Geometry2D.intersect_polygons(sliceable_polygon, rectangle_points):
			sliceable.slice(rectangle_points)
			Global.score += 1


func create_rectangle_from_line(slicer_start: Vector2, slicer_end: Vector2, thickness: float) -> Array:
	var direction = slicer_end - slicer_start
	var normal = Vector2(-direction.y, direction.x).normalized()

	var half_thickness = thickness / 2.0

	# Compute the four vertices of the rectangle
	var p1 = self.global_transform * (slicer_start + normal * half_thickness)
	var p2 = self.global_transform * (slicer_start - normal * half_thickness)
	var p3 = self.global_transform * (slicer_end - normal * half_thickness)
	var p4 = self.global_transform * (slicer_end + normal * half_thickness)

	return [p1, p2, p3, p4]
