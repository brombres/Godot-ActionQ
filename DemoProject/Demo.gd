@tool
extends Node2D

func _ready():
	prints( ProgressFn.pretty_function_names() )
	prints( ProgressFn.find("Bounce In") )

