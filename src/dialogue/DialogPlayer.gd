extends Node

class_name DialoguePlayer

signal started
signal finished(next)

var title: String = ""
var char_name: String = ""
var text: String = ""
var background: String = ""
var characters: Array = [] # what characters to display
var props: Array = [] # what props to display secondary characters, etc.
var choices: Array = []

var text_speed = 1

var current_line: Dictionary = {}
var _conversation: Array
var _index_current: int = 0
var is_question: bool = false


func start(dialogue_dict):
	# Takes a dictionary of conversation data returned by Dialogue.load()
	# and stores it in an array
	
	emit_signal("started")
	_conversation = dialogue_dict.values()
	_index_current = 0
	current_line = _conversation[_index_current]
	_update()


func next():
	if _index_current >= _conversation.size()-1:
		get_parent().clear() # hide everything but the background
		return false
	
	_index_current += 1
	assert(_index_current <= _conversation.size())
	current_line = _conversation[_index_current]
	_update()
	return true


func _update():
	if _conversation[_index_current].has("next"):
		emit_signal("finished", _conversation[_index_current].next)
		return

	if _conversation[_index_current].has("type"):
		choices = _conversation[_index_current].choices
		title = _conversation[_index_current].title
		return
	
	if _conversation[_index_current].has("title"):
		title = _conversation[_index_current].title
	if _conversation[_index_current].has("text"):
		text = _conversation[_index_current].text
	
	char_name = _conversation[_index_current].name
	background = _conversation[_index_current].background
	characters = _conversation[_index_current].characters
	props = _conversation[_index_current].props
	text_speed = _conversation[_index_current].text_speed

	
	if _index_current == _conversation.size() - 1:
		emit_signal("finished", "")


func reset():
	title = ""
	text = ""
	background = ""
	characters = [] # what characters to display
	props = [] # what props to display secondary characters, etc.
	choices = []
	
	text_speed = 1
	
	current_line = {}
	_conversation = []
	_index_current = 0
	is_question = false
