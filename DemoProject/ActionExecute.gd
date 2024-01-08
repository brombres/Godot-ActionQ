class_name ActionExecute extends Action

## An optional node that can be referenced from the statement using the variable name 'node'.
@export var node:Node

## A GDScript statement to be executed. May reference the optional 'node'.
@export var statement := "" :
	set(value):
		if statement != value:
			statement = value

var _configured := false
var _script:GDScript
var _context:Object

const _source_template:String = """
extends Object

func execute( node:Node ):
	node = node # eliminate unused var warning
	%s
"""

func _init( _statement="", _node=null ):
	self.statement = _statement
	self.node = _node

func _reset():
	_configured = false
	_script = null
	_context = null

func on_start():
	if not _configured:
		if statement != "":
			_script = GDScript.new()
			_script.source_code = _source_template % statement
			_script.reload()

			_context = Object.new()
			_context.set_script( _script )
		_configured = true

## Override and return true if this action is finished, false if it needs to be updated again.
func update( _dt:float )->bool:
	if _context: _context.execute( node )
	return true
