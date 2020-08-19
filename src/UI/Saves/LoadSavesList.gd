extends HBoxContainer


onready var save_button_scene: Resource = load("res://src/UI/Saves/Save.tscn")


func _ready():
	$Save.connect("save_created", self, "_on_save_created")
	$Save.connect("save_loaded", self, "_on_save_loaded")


func _on_save_loaded():
	var confirmed = yield(UI.ask_confirmation("Ainda preciso implementar o sistema pra carregar os saves"), "answered")


func _on_save_created():
	add_save_button()


func organize():
	var children = get_children()
	var last_child = children[children.size()-1]
	move_child(last_child, 0)



func add_save_button():
	var save_button = save_button_scene.instance()
	# Forgot this, caused so much headache ;-;
	save_button.connect("save_created", self, "_on_save_created")
	
	add_child(save_button)
	organize()




