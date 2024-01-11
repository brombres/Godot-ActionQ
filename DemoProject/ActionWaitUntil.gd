class_name ActionWaitUntil extends Action

@export var node:Node

@export var expression := "" :
	set(value):
		if expression != value:
			expression = value
			_callable = null

var _callable:DynamicFunction
var _callback:Callable

func _init( callback=null, _node=null ):
	if callback: _callback = callback
	node = _node

func on_start():
	if not _callable and expression != "":
		_callable = DynamicFunction.new( ["node"], expression, true )

func update( _dt:float )->bool:
	if _callable:   return _callable.execute( [node] )
	elif _callback: return _callback.call()
	return true

