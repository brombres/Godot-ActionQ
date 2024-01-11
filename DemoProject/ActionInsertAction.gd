extends Action

func update( _dt:float )->bool:
	add_sibling( ActionExecute.new(func():print("Huzzah!")) )
	return true
