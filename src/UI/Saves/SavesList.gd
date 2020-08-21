#extends HBoxContainer
#
#
#onready var save_button_scene: Resource = load("res://src/UI/Saves/Save.tscn")
#
#
#var has_added_children = false
#
#
#func organize():
#	var children = get_children()
#	var children_size = children.size()
#	move_child(children[children_size-1], 0)
#
#func add_save_button():
#	var save_button = save_button_scene.instance()
#	add_child(save_button)
#	organize()
#
#
