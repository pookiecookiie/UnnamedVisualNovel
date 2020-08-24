extends Control


onready var confirmation_dialog = load("res://src/UI/ConfirmAction/ConfirmAction.tscn")

onready var animation_player: AnimationPlayer = $AnimationPlayer


func ask_confirmation(confirmation_text: String):
	var confirmation_instance: ConfirmationDialog = confirmation_dialog.instance()
	get_tree().get_root().add_child(confirmation_instance)
	confirmation_instance.dialog_text = confirmation_text
	confirmation_instance.popup_centered(Vector2(100, 100))
	return confirmation_instance

