extends Node


var mouse_sensitivity := 0.002
var controller_sensitivity := 0.05
var zoom_sensitibity := 1.0
var invert_y_axis := false


func invert_y_to_int() -> int:
	return (int(invert_y_axis) * 2) - 1
