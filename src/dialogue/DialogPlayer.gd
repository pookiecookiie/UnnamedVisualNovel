extends Node

class_name DialoguePlayer

signal started()
signal updated(data) 
signal finished()

var _conversation: Array = []
var _index_current: int = 0
var current

var current_dialog: String = ""

func start(dialog, index=0):
	emit_signal("started")
	current_dialog = dialog
	
	var dialogue_dict = Loader.get_dialog(dialog)
	_conversation = dialogue_dict.values()
	_index_current = index
	current = _conversation[index]
	emit_signal("updated", current)


func next():
	if _index_current >= _conversation.size()-1:
		emit_signal("finished")
		return
	
	_index_current += 1
	var progress = {"current_dialog": current_dialog, "dialog_index": _index_current}
	ProgressManager.save_progress(progress)
	current = _conversation[_index_current]
	emit_signal("updated", current)


func reset():
	_conversation = []
	_index_current = 0
	current = null
