@tool
extends Node2D

func _ready():
	prints( ProgressFn.title_case_function_names() )
	prints( ProgressFn.find("Bounce In") )

