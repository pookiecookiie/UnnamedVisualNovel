extends Control


onready var TextEditor = $Text/Box/Margin/TextEditor
onready var Text = $Text/Box/Margin/Text
onready var NameEdit = $Text/NameEdit

export(bool) var debug : bool = true

var editing : bool = false
var is_playing : bool = false

var dialog_speed : float = 1
var dialog_line : int = 0


signal line_animation_finished

# Debug
signal error(message, from)
signal warn(message, from)
signal info(message, from)
signal success(message, from)
 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Debug
	connect("error", Debug, "_on_error")
	connect("warn", Debug, "_on_warn")
	connect("info", Debug, "_on_info")
	connect("success", Debug, "_on_success")
	
	connect("line_animation_finished", self, "_on_line_animation_finished")
	
	update_editing_mode()
	load_dialog()


func _process(delta):
	if is_playing:
		step_dialog_animation(delta)


func _input(event:InputEvent):
	if event.is_action_pressed("middle_click"):
		toggle_editing_mode()
	
	if event.is_action_pressed("left_click"):
		play_dialog()


func _on_line_animation_finished():
	print("Finished line")


func update_dialog(dialog:Dictionary):
	if dialog_line >= dialog.lines.size():
		dialog_line = 0
		return
	
	NameEdit.text = dialog.name
	
	TextEditor.text = dialog.lines[dialog_line].text
	Text.text = dialog.lines[dialog_line].text
	
	self.dialog_speed = dialog.lines[dialog_line].text_speed


func load_dialog():
	yield(Cache, "cache_loaded")
	var dialog = Cache.cache.dialogX[0]
	update_dialog(dialog)


func step_dialog_animation(delta):
	var speed_tuning = .7
	if Text.percent_visible < 1:
		Text.percent_visible += speed_tuning * dialog_speed * delta
	else:
		is_playing = false
		emit_signal("line_animation_finished")


func play_dialog():
	update_dialog(Cache.cache.dialogX[0])
	# Cannot play the dialog when editing
	Text.percent_visible = 0
	self.editing = false
	update_editing_mode()
	
	is_playing = true
	dialog_line+=1


func update_editing_mode():
	TextEditor.visible = self.editing
	Text.visible = !self.editing
	NameEdit.editable = self.editing


func toggle_editing_mode():
	self.editing = !self.editing
	update_editing_mode()
	
	emit_signal("info", "Editting: " + str(self.editing), self.name)

