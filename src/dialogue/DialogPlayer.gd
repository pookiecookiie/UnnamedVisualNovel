extends Node

class_name DialoguePlayer

signal started
signal finished

var title: String = ""
var text: String = ""
var background: String = ""
var characters: Array = [] # what characters to display and where
var props: Array = [] # what props to display... maybe

var _conversation: Array
var _index_current: int = 0


func start(dialogue_dict):
	# Takes a dictionary of conversation data returned by Dialogue.load()
	# and stores it in an array
	emit_signal("started")
	_conversation = dialogue_dict.values()
	_index_current = 0
	_update()


func next():
	if _index_current+1 >= _conversation.size():
		return
	
	_index_current += 1
	assert(_index_current <= _conversation.size())
	_update()


func _update():
	text = _conversation[_index_current].text
	title = _conversation[_index_current].name
	background = _conversation[_index_current].background
	characters = _conversation[_index_current].characters
	props = _conversation[_index_current].props
	
	if _index_current == _conversation.size() - 1:
		emit_signal("finished")
