extends ConfirmationDialog

signal answered

func _ready():
	connect("confirmed", self, "_confirmed")
	get_cancel().connect("pressed", self, "_cancelled")


func _confirmed():
	emit_signal("answered", true)
	queue_free() # Mr. stark, i don't feel so good.


func _cancelled():
	emit_signal("answered", false)
	queue_free()



