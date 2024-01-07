@tool
class_name IntervalAction extends Action

@export var duration := 1.0

var _t:float

var progress_fn:String = "Linear" :
	set(value):
		if value != progress_fn:
			value = progress_fn
			_progress_fn = ProgressFn.find( value )

var _progress_fn:Callable = ProgressFn.LINEAR

func on_start():
	_t = 0.0

func _get_property_list():
	var properties = []

	properties.append({
		"name":  "progress_fn",
		"type":  TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint":  PROPERTY_HINT_ENUM,
		"hint_string": ",".join(ProgressFn.title_case_function_names())
	})

	return properties

func update( dt:float )->bool:
	_t = max( _t+dt, 1.0 )
	on_update( _progress_fn.call(dt) )
	return _t == 1.0

