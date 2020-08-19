extends Node

signal scene_changed()

onready var MainMenu = preload("res://src/UI/main_menu/MainMenu.tscn")
#onready var Options
#onready var Credits

onready var Introduction = preload("res://src/dialogue/Dialog.tscn")


var Scenes = {
	"Introduction": Introduction,
	
}


onready var animation_player = $AnimationPlayer

var current_scene = MainMenu


func change_scene(scene_path: String, animation: String, delay: float=0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play(animation)
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(scene_path) == OK)
	animation_player.play_backwards(animation)
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed", scene_path)


func change_scene_from_button(button: Button):
	var scene_path = button.scene_path
	var animation = button.animation
	var delay = button.delay
	
	if scene_path.empty():
		printerr("I did not work because the scene path was EMPTY.")
		return # IGNORE ME
	change_scene(scene_path, animation, delay)

