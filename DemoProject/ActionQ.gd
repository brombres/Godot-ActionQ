@tool
class_name ActionQ extends Action

@export var auto_execute := false
@export var looping      := false
@export var asynchronous := false

var _running  := false
var _finished := false
var _ip := 0
var _cur_action = null
var _actions := []

## Called when this ActionQ begins to execute.
func on_start():
	_finished = false
	_running = true
	_ip = 0
	_actions = []

## Return 'true' when finished.
func update( dt:float )->bool:
	if auto_execute and not _finished and not _running and not Engine.is_editor_hint():
		run()

	if not _running: return false

	on_update( dt )
	if not _finished:
		if asynchronous:
			var write_i = 0
			for i in range(_actions.size()):
				var action = _actions[i]
				if action.update( dt ):
					if action.has_method("on_finish"): action.on_finish()
					action.on_finish()
				else:
					_actions[write_i] = action
					write_i += 1
			while _actions.size() > write_i: _actions.pop_back()
			_finished = (_actions.size() == 0)

		else:
			while _cur_action and _cur_action.update( dt ):
				if _cur_action.has_method("on_finish"): _cur_action.on_finish()
				_ip += 1
				_finished = not _advance_action()

		if not _finished: return false

	if looping:
		run()
		return false
	else:
		_running = false
		return true

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
				if action.has_method("save_state"):
					actions.push_back( {"ip":action.get_index(),"state":action.save_state()} )
		elif _cur_action:
			if _cur_action.has_method("save_state"):
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
	_ip          = 0

	var actions = dictionary.actions
	if actions:
		if asynchronous:
			_actions.clear()
			for action_info in actions:
				var action = get_child( action_info.ip )
				_actions.push_back( action )
				if action.has_method("restore_state"): action.restore_state( action_info.state )
		elif actions.size():
			var action_info = actions[0]
			_ip = action_info.ip
			if _advance_action() and action_info.state:
				if _cur_action.has_method("restore_state"): _cur_action.restore_state( action_info.state )

## Begins execution of this ActionQ. Actions are processed in the _process() callback.
func run():
	_finished = false
	_running = true
	_ip = 0
	_actions.clear()
	if asynchronous:
		while _advance_action():
			_actions.push_back( _cur_action )
			_ip += 1
	else:
		_advance_action()

func _advance_action()->bool:
	var child_count = get_child_count()

	while _ip < child_count:
		_cur_action = get_child( _ip )
		if _cur_action.visible and _cur_action.has_method("update"):
			if _cur_action.has_method("on_start"): _cur_action.on_start()
			return true
		_ip += 1

	_cur_action = null
	return false

func _process( dt:float ):
	update( dt )

