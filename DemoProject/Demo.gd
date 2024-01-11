extends Node2D

var mouse_clicked := false

func _ready():
	pass

#	var script = GDScript.new()
#	script.source_code = """
#extends Object
#func _init():
#	prints( "init()" )
#
#"""
#	script.reload()
#
#	var object = Object.new()
#	prints("setting script")
#	object.set_script( script )
#	prints("script set")
#	object.test()


func test():
	prints( "Success!" )

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_clicked = true

				#event.position)
			#else:
				#print("Left button was released")
