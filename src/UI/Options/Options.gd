extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	$Back.connect("pressed", self, "_on_back_pressed")


func _on_back_pressed():
	SceneManager.change_scene_from_button($Back)
