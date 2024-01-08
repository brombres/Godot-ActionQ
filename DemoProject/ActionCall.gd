class_name CallAction extends Action

var callable:Callable

func _init( _callable:Callable ):
	self.callable = _callable

## Override and return true if this action is finished, false if it needs to be updated again.
func update( _dt:float )->bool:
	if callable: callable.call()
	return true
