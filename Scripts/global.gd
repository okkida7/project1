extends Node

var gravity_multiplier = 2.0
var mass_multiplier = 2.0

func increase_gravity_multiplier(value):
	gravity_multiplier *= value

func increase_mass_multiplier(value):
	mass_multiplier *= value
