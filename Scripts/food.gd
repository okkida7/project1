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

func calculate_intersection(from, to):
	# Your intersection logic here
	return false

func split_sprite(intersection):
	# Your sprite splitting logic here
