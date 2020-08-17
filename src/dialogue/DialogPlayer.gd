extends Node

class_name DialoguePlayer

signal updated(data) 
signal finished(next)

var _conversation: Array = []
var _index_current: int = 0


func start(dialogue_dict):
	_conversation = dialogue_dict.values()
	_index_current = 0
	emit_signal("updated", _conversation[0])


func next():
	if _index_current >= _conversation.size()-1:
		var curr = _conversation[_index_current]
		if curr.has("next"):
			emit_signal("finished", curr.next)
		else:
			emit_signal("finished", "")
		return
	
	_index_current += 1
	emit_signal("updated", _conversation[_index_current])


func reset():
	_conversation = []
	_index_current = 0
