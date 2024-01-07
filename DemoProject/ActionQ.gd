@tool
class_name ActionQ extends Action

@export var auto_execute := false
@export var looping      := false
@export var asynchronous := false

var _running  := false
var _finished := false
var _ip := -1
var _cur_action = null
var _actions := []

func on_start():
	_finished = false
	_running = true
	_ip = -1
	_actions = []

## Return 'true' when finished.
func update( dt:float )->bool:
	if auto_execute and not _finished and not _running and not Engine.is_editor_hint():
		run()

	if not _running: return false

	on_update( dt )

	var finished = false

	if asynchronous:
		var write_i = 0
		for i in range(_actions.size()):
			var action = _actions[i]
			if action.update( dt ):
				action.on_finish()
				action.on_effect()
			else:
				_actions[write_i] = action
				write_i += 1
		while _actions.size() > write_i: _actions.pop_back()
		finished = (_actions.size() == 0)

	else:
		while _cur_action and _cur_action.update( dt ):
			_cur_action.on_finish()
			_cur_action.on_effect()
			finished = not _advance_action()

	if not finished: return false

	if looping:
		run()
		return false
	else:
		_finished = true
		_running = false
		return true

func on_finish():
	pass

func on_effect():
	pass

## Called directly on an ActionQ or indirectly when this action is an active action of an
## ActionQ that save_state() is called on.
func save_state()->Dictionary:
	var result:Dictionary = {
		"auto_execute":auto_execute,
		"looping":looping,
		"asynchronous":asynchronous,
		"running":_running,
		"finished":_finished,
	}

	if _running:
		var actions:Array[int] = []
		if _actions.size():
			for action in _actions:
				actions.push_back( {"ip":action.get_index(),"state":action.save_state()} )
		elif _cur_action:
			actions.push_back( {"ip":_cur_action.get_index(),"state":_cur_action.save_state()} )
		elif not asynchronous:
			actions.push_back( {"ip":_ip,"state":null} )
		result["actions"] = actions

	return result

## Called directly on an ActionQ or indirectly when this action is an active action of an
## ActionQ that restore_state() is called on.
func restore_state( dictionary:Dictionary ):
	auto_execute = dictionary.auto_execute
	looping      = dictionary.looping
	asynchronous = dictionary.asynchronous
	_running     = dictionary.running
	_finished    = dictionary.finished

	var actions = dictionary.actions
	if actions:
		if asynchronous:
			_actions.clear()
			for action_info in actions:
				var action = get_child( action_info.ip )
				_actions.push_back( action )
				action.restore_state( action_info.state )
		elif actions.size():
			var action_info = actions[0]
			_cur_action = get_child( action_info.ip )
			if action_info.state:
				_cur_action.restore_state( action_info.state )

func run():
	_finished = false
	_running = true
	_ip = -1
	_actions = []
	if asynchronous:
		while _advance_action():
			_actions.push_back( _cur_action )
	else:
		_advance_action()

func _advance_action()->bool:
	_ip += 1
	var child_count = get_child_count()

	while _ip < child_count:
		_cur_action = get_child( _ip )
		if _cur_action.has_method("on_start"):
			_cur_action.on_start()
			return true
		_ip += 1

	_cur_action = null
	return false

func _process( dt:float ):
	update( dt )

