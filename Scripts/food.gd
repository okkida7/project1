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

# Cody's newest update:

func crop_image(original_image: Image, crop_rect: Rect2) -> Image:
    var cropped = Image.new()
    cropped.create(crop_rect.size.x, crop_rect.size.y, false, original_image.get_format())
    cropped.blit_rect(original_image, crop_rect, Vector2(0, 0))
    return cropped

func generate_half_sprite(cropped_image: Image, position: Vector2):
    var texture = ImageTexture.new()
    texture.create_from_image(cropped_image)
    var new_sprite = Sprite.new()
    new_sprite.texture = texture
    new_sprite.position = position
    return new_sprite

func split_sprite(intersections):
    var original_image = $Sprite.texture.get_data()
    original_image.lock()

    # Calculate the crop rectangles based on the slice line and sprite dimensions.
    # This logic will vary based on how exactly you're slicing the sprite.
    var rect1 = Rect2(0, 0, intersections[0].x, original_image.get_height())
    var rect2 = Rect2(intersections[1].x, 0, original_image.get_width() - intersections[1].x, original_image.get_height())
    
    var cropped_image1 = crop_image(original_image, rect1)
    var cropped_image2 = crop_image(original_image, rect2)

    # Generate new sprites and set their positions relative to the original sprite.
    var new_sprite1 = generate_half_sprite(cropped_image1, Vector2(rect1.position.x, rect1.position.y))
    var new_sprite2 = generate_half_sprite(cropped_image2, Vector2(rect2.position.x, rect2.position.y))

    # Add these new sprites to new RigidBody2D nodes (or other types depending on your game logic)
    var body1 = RigidBody2D.new()
    body1.add_child(new_sprite1)
    body1.global_position = self.global_position + rect1.position

    var body2 = RigidBody2D.new()
    body2.add_child(new_sprite2)
    body2.global_position = self.global_position + rect2.position

    # Add new bodies to the scene and remove the original one.
    get_parent().add_child(body1)
    get_parent().add_child(body2)
    queue_free()
