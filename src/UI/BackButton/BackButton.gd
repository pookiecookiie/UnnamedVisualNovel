extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	print("Go Back")
	SceneManager.go_back()

