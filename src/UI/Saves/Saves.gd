#extends HBoxContainer
#
#onready var save_button_scene: Resource = load("res://src/UI/Saves/Save.tscn")
#
#var saves = 0
#
#func _ready():
#	$Save.connect("save_created", self, "_on_save_created")
#	$Save.connect("save_loaded", self, "_on_save_loaded")
#
#	for save in ProgressManager.saves:
#		var save_button = save_button_scene.instance()
#		save_button.connect("save_created", self, "_on_save_created")
#		save_button.connect("save_loaded", self, "_on_save_loaded")
#		save_button.connect("removed", self, "_on_save_removed")
#		add_child(save_button)
#
#		save_button.update_save("name", save.name)
#		save_button.update_save("dialog", save.dialog)
#		save_button.update_save("thumbnail", UI.get_screenshot(save.thumbnail))
#		save_button.update_save("index", save.index)
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
#func _on_save_removed(index):
#	ProgressManager.remove_save(index)
#
#
#func organize():
#	var children = get_children()
#	var last_child = children[children.size()-1]
#	move_child(last_child, 0)
#
#
##Creating a new button
#func add_save_button():
#	var save_button = save_button_scene.instance()
#	# Forgot this, caused so much headache ;-;
#	save_button.connect("save_created", self, "_on_save_created")
#	save_button.connect("removed", self, "_on_save_removed")
#
#	save_button.save.index = -1
#
#
#	# These are all the buttons with saves
#	get_children()[0].make_save(saves)
#	saves+=1
#
#	var save_btn_index = 0
#	for save_btn in get_children():
#		save_btn.made_save(save_btn_index)
#		save_btn_index += 1
#
#	add_child(save_button)
#	organize()
