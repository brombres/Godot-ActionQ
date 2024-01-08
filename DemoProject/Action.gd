class_name Action extends Node2D

## Called when this action begins to execute. Override and set up initial state.
func on_start():
	pass

## Override and update the state of this action.
func on_update( _progress:float ):
	pass

## Called when this action is finished. Override and perform any cleanup necessary.
func on_finish():
	pass

## Called directly on an ActionQ or indirectly when this action is an active action of an
## ActionQ that save_state() is called on.
func save_state()->Dictionary:
	return {}

## Called directly on an ActionQ or indirectly when this action is an active action of an
## ActionQ that restore_state() is called on.
func restore_state( _dictionary:Dictionary ):
	pass

## Override and return true if this action is finished, false if it needs to be updated again.
func update( dt:float )->bool:
	on_update( dt )
	return true
