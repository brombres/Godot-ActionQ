class_name TweenAction extends Action

var tween:Tween

func on_start():
	tween = create_tween()

func on_update( _progress:float )->bool:
	return not tween.is_valid()
