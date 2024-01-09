class_name ActionWait extends Action

@export var seconds := 0.5

var _remaining:float

func on_start():
	_remaining = seconds

## Restores the state of this action from a dictionary.
func restore_state( dictionary:Dictionary ):
	seconds = dictionary.seconds
	_remaining = dictionary.remaining

## Saves the state of this action to a dictionary.
func save_state()->Dictionary:
	return { "seconds":seconds, "remaining":_remaining }

func update( dt:float )->bool:
	_remaining = max( _remaining-dt, 0.0 )
	return _remaining == 0.0

