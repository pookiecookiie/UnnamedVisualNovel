extends Control


onready var confirmation_dialog = load("res://src/UI/ConfirmAction/ConfirmAction.tscn")

onready var animation_player: AnimationPlayer = $AnimationPlayer

signal screenshot(file_name)

var thumbnails: int = 0

func _ready():
	if Cache.cache.has("thumbnails"):
		thumbnails = Cache.cache.thumbnails


func _exit_tree():
	Cache.store("thumbnails", thumbnails)


func ask_confirmation(confirmation_text: String):
	var confirmation_instance: ConfirmationDialog = confirmation_dialog.instance()
	get_tree().get_root().add_child(confirmation_instance)
	confirmation_instance.dialog_text = confirmation_text
	confirmation_instance.popup_centered(Vector2(100, 100))
	return confirmation_instance


func screenshot():
	print("Creating a new screenshot")
	
	# Get Dialog Scene viewport
	var img = get_viewport().get_texture().get_data()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	img.flip_y()
	var file_name = "thumbnail_%s" % thumbnails
	img.save_png("user://thumbnails/%s.png" % file_name)
	thumbnails+=1
	
	emit_signal("screenshot", file_name)


func get_screenshot(name):
	print("Getting existing screenshot")
	
	var image = load("users://thumbnails/%s.png" % name)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture
