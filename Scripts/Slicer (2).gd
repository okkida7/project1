extends Line2D

@onready var slicer_start = get_point_position(0)
@onready var slicer_end = get_point_position(1)
var intersecting_body: Node = null

var slice_possible = false

func _process(delta):
	if Input.is_action_just_pressed("Slice") and slice_possible:
		print("slice triggered")
		# intersecting_body.freeze = true
		
		intersecting_body.slice(self.global_transform * slicer_start, self.global_transform * slicer_end)



func _on_area_2d_body_entered(body):
	if body.is_in_group("sliceable"):
		slice_possible = true
		intersecting_body = body
		print("entered: ", intersecting_body)


func _on_area_2d_body_exited(body):
	if body.is_in_group("sliceable"):
		slice_possible = false
		print("exited: ", intersecting_body)
		intersecting_body = null

