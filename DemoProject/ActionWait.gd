class_name ActionWait extends IntervalAction

@export var seconds := 0.5

var _remaining:float

func on_start():
	_remaining = seconds

func on_finish():
	prints( seconds )

## Called directly on an ActionQ or indirectly when this action is an active action of an
## ActionQ that save_state() is called on.
func save_state()->Dictionary:
	return { "seconds":seconds }

## Called directly on an ActionQ or indirectly when this action is an active action of an
## ActionQ that restore_state() is called on.
func restore_state( dictionary:Dictionary ):
	seconds = dictionary.seconds

func update( dt:float )->bool:
	on_update( dt )
	_remaining -= dt
	return _remaining <= 0

