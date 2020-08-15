extends Node


signal step_dialog_animation(text)
signal end_dialog_animation(text)

var default_time: float = 0.1 # seconds
var default_interpolation: float = 0.025 # Speed

var target_text: String = ""
var current_text: String = ""

var text_index: int = 0
var text_speed: float = 1 # 100 % the default speed
var percent_visible: float = 0
var interpolation_speed: float = 1

var is_animating: bool = false

func _ready():
	connect("end_dialog_animation", self, "_on_end_dialog_animation")
	set_text_speed(text_speed)
	set_interpolation_speed(interpolation_speed)


func _on_end_dialog_animation():
	self.is_animating = false
	current_text = ""
	target_text = ""
	text_index = 0
	percent_visible = 0


func set_interpolation_speed(speed):
	interpolation_speed = default_interpolation * speed
	$Interpolator.wait_time = interpolation_speed


func start_interpolation():
	if self.is_animating:
		return
	
	percent_visible = 0
	self.is_animating = true
	interpolate()


func interpolate():
	$Interpolator.start()
	yield($Interpolator, "timeout")
	step_interpolation()


func step_interpolation():
	if percent_visible >= 1:
		end_interpolation_animation()
	else:
		percent_visible += lerp(0, 1, interpolation_speed)
		emit_signal("step_dialog_animation", percent_visible)
		interpolate()


func end_interpolation():
	self.is_animating = false
	percent_visible = 0
	emit_signal("step_dialog_animation", percent_visible)
	emit_signal("end_dialog_animation")


func end_interpolation_animation():
	self.is_animating = false
	percent_visible = 1
	emit_signal("step_dialog_animation", percent_visible)


func set_text_speed(speed):
	text_speed = default_time * (1/speed)


#Might be buggy, because i didn't test it since i changed my mind on how it was
# supposed to work, using percent_visible and not this stuff
# First call
func start_animation(text):
	# End result text is this
	target_text = text
	self.is_animating = true
	animate()


# Called to run the next animation step OR end the animation
func animate():
	$Timer.start()
	yield($Timer, "timeout")
	step()


# Steps the animation
func step():
	if current_text != target_text:
		current_text += target_text[text_index]
		text_index += 1
		emit_signal("step_dialog_animation", current_text)
		animate()
	else:
		emit_signal("end_dialog_animation")


func end_animation():
	current_text = target_text
	emit_signal("step_dialog_animation")
