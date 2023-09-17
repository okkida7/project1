extends RigidBody2D

var velocity = Vector2(0, 200)

func _ready():
	self.texture = preload("res://pizza.png")
	get_parent().connect("slice_made", self, "_on_slice_made")

func _physics_process(delta):
	position += velocity * delta

func _on_slice_made(from, to):
	# calculate the intersection point
	# and split the sprite if it intersects
	var intersection = calculate_intersection(from, to)
	if intersection:
		split_sprite(intersection)

# Cody: just update two funcs:
func calculate_intersection(from, to):
	var my_global_position = self.global_position
	var local_from = from - my_global_position
	var local_to = to - my_global_position
	
	var collision_polygon = $CollisionPolygon2D
	var points = collision_polygon.polygon

	var intersections = []
	for i in range(points.size()):
		var p1 = points[i]
		var p2 = points[(i + 1) % points.size()]

		var intersect = Geometry.segment_intersects_segment_2d(p1, p2, local_from, local_to)
		if intersect:
			intersections.append(intersect)
	
	if intersections.size() == 2:
		return intersections
	else:
		return null

func split_sprite(intersections):
	print("Slicing sprite at: ", intersections)
	# we need a sprite slicing logic here
	queue_free()  # For this example, we'll just delete the sprite
