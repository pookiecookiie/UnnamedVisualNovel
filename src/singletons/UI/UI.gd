extends Control


onready var confirmation_dialog = load("res://src/UI/ConfirmAction/ConfirmAction.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func ask_confirmation(confirmation_text: String):
	var confirmation_instance: ConfirmationDialog = confirmation_dialog.instance()
	get_tree().get_root().add_child(confirmation_instance)
	confirmation_instance.dialog_text = confirmation_text
	confirmation_instance.popup_centered(Vector2(100, 100))
	return confirmation_instance
