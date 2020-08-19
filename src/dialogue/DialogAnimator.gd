extends Node

signal started
signal updated(text)
signal finished

var wait_time: float = 1

# Animating writting.
# Can only be used if there are no bbcode tags such as [color=#FFF][/color]
# It looks odd because it writes the tag letter by letter
# Maybe fixable, but i just don't want to deal with it, for my purposes
# It should work just fine
var target_text: String = ""
var current_text: String = ""
var text_progress: int = 0


var is_animating: bool = false

var parent


func _ready():
	$Tween.connect("tween_started", self, "_on_tween_start")
	$Tween.connect("tween_step", self, "_on_tween_step")
	$Tween.connect("tween_completed", self, "_on_tween_completed")
	
	parent = get_parent()


func _on_tween_start(_object, _key):
	pass


func _on_tween_step(_object, _key, _elapsed, _value):
	pass


func _on_tween_completed(object, key):
	$Tween.reset(object, key)
	reset()
	emit_signal("finished")


# Animate some text towards some other text, letter by letter
# Not necessary for this game i believe, but here is the reminder if we need it
func animate():
	pass


func interpolate():
	self.is_animating = true
	$Tween.interpolate_property(parent.Text, "percent_visible", 0, 1, wait_time)
	$Tween.start()
	

func skip_interpolation():
	$Tween.playback_speed = 10



func reset():
	self.is_animating = false
	current_text = ""
	target_text = ""
	text_progress = 0
	$Tween.playback_speed = 1
