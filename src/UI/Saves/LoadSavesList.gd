#extends HBoxContainer
#
#
#onready var save_button_scene: Resource = load("res://src/UI/Saves/Save.tscn")
#
#
#func _ready():
#	for save in ProgressManager.saves:
#		var save_button = save_button_scene.instance()
#		add_child(save_button)
#		save_button.update_save("name", "Save %s" % str(save.index).pad_zeros(2))
#		save_button.update_save("dialog", save.dialog)
#		save_button.update_save("thumbnail", save.thumbnail)
#		save_button.update_save("index", save.index)
#		organize()
#
#
#
#func _on_save_loaded():
#	var confirmed = yield(UI.ask_confirmation("Ainda preciso implementar o sistema pra carregar os saves"), "answered")
#
#
#func _on_save_created():
#	add_save_button()
#
#
#func organize():
#	var children = get_children()
#	var last_child = children[children.size()-1]
#	move_child(last_child, 0)
#
#
#
#func add_save_button():
#	var save_button = save_button_scene.instance()
#	# Forgot this, caused so much headache ;-;
#	save_button.connect("save_created", self, "_on_save_created")
#
#	add_child(save_button)
#	organize()
#
#
#
#
