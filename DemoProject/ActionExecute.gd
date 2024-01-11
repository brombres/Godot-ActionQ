class_name ActionExecute extends Action

## An optional node that can be referenced from the statement using the variable name 'node'.
@export var node:Node

## A GDScript statement to be executed. May reference the optional 'node'.
@export var statement := "" :
	set(value):
		if statement != value:
			statement = value
			_callable = null

var _callable:DynamicFunction
var _callback:Callable

func _init( callback=null, _node=null ):
	if callback: _callback = callback
	node = _node

func on_start():
	if not _callable and statement != "":
		_callable = DynamicFunction.new( ["node"], statement )

## Override and return true if this action is finished, false if it needs to be updated again.
func update( _dt:float )->bool:
	if _callable:   _callable.execute( [node] )
	elif _callback: _callback.call()
	return true
