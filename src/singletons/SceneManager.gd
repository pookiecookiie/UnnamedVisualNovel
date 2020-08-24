extends Node

signal scene_changed()

onready var MainMenu = preload("res://src/UI/main_menu/MainMenu.tscn")
onready var Saves = preload("res://src/UI/Saves/Saves.tscn")
onready var Options = preload("res://src/UI/Options/Options.tscn")
onready var Credits = preload("res://src/UI/Credits/Credits.tscn")

onready var Dialog = "res://src/dialogue/Dialog.tscn"


var current_scene_index: int = 0
var scene_history: Array = ["res://src/UI/main_menu/MainMenu.tscn"]


func change_scene(scene_path: String, animation: String, delay: float=0.5):
	yield(get_tree().create_timer(delay), "timeout")
	UI.animation_player.play(animation)
	yield(UI.animation_player, "animation_finished")
	_change_scene(scene_path)
	UI.animation_player.play_backwards(animation)
	yield(UI.animation_player, "animation_finished")
	emit_signal("scene_changed")


func change_scene_from_button(button: Button):
	var scene_path = button.scene_path
	var animation = button.animation
	var delay = button.delay
	
	if scene_path.empty():
		printerr("I did not work because the scene path was EMPTY.")
		return # IGNORE ME
	change_scene(scene_path, animation, delay)


func go_back():
	if current_scene_index <= -1:
		return
	
	scene_history.pop_back()

	current_scene_index -= 1
	change_scene(scene_history[current_scene_index], "fade_black", 0.25)
	print(scene_history)


func _change_scene(scene_path: String):
	get_tree().change_scene(scene_path)
	if scene_path == "res://src/UI/main_menu/MainMenu.tscn":
		return
	scene_history.append(scene_path)
	current_scene_index += 1
