extends Node

class_name DialoguePlayer

signal updated(data) 
signal finished

var _conversation: Array = []
var _index_current: int = 0
var current


func start(dialogue_dict):
	_conversation = dialogue_dict.values()
	_index_current = 0
	current = _conversation[0]
	emit_signal("updated", current)


func next():
	if _index_current >= _conversation.size()-1:
		return
	
	_index_current += 1
	current = _conversation[_index_current]
	emit_signal("updated", current)


func reset():
	_conversation = []
	_index_current = 0
	current = null
