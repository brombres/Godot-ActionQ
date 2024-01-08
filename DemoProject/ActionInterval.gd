@tool
class_name IntervalAction extends Action

@export var duration := 1.0

var _t:float

var progress_fn:String = "Linear" :
	set(value):
		if progress_fn != value:
			progress_fn = value
			_progress_fn = ProgressFn.find( value )

var _progress_fn:Callable = ProgressFn.LINEAR

func on_start():
	_t = 0.0

## Restores the state of this action from a dictionary.
func restore_state( dictionary:Dictionary ):
	_t = dictionary.t
	duration = dictionary.duration

## Saves the state of this action to a dictionary.
func save_state()->Dictionary:
	return { "t":_t, "duration":duration }

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
	_t = min( _t+dt, duration )
	on_update( _progress_fn.call(dt) )
	return _t == duration

