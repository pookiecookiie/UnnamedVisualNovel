extends Node

class_name DialoguePlayer

signal started
signal finished

var title: String = ""
var text: String = ""
var background: String = ""
var characters: Array = [] # what characters to display
var props: Array = [] # what props to display secondary characters, etc.

var text_speed = 1
var name_font = ""
var name_color = ""
var text_font = ""
var text_color = ""


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
		get_parent().get_node("Text").hide()
		get_parent().get_node("PropsContainer").hide()
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
	text_speed = _conversation[_index_current].text_speed
	name_font = _conversation[_index_current].name_font
	name_color = _conversation[_index_current].name_color
	text_font = _conversation[_index_current].text_font
	text_color = _conversation[_index_current].text_color
	
	if _index_current == _conversation.size() - 1:
		emit_signal("finished")
