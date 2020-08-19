extends VBoxContainer


onready var MainMenu = load("res://src/UI/main_menu/MainMenu.tscn")
onready var Options = load("res://src/UI/Options/Options.tscn")
onready var Credits = load("res://src/UI/Credits/Credits.tscn")

onready var Introduction = load("res://src/dialogue/Dialog.tscn")



func _ready():
	$Start.connect("pressed", self, "_on_start_pressed")
	$Continue.connect("pressed", self, "_on_continue_pressed")
	$Saves.connect("pressed", self, "_on_saves_pressed")
	$Options.connect("pressed", self, "_on_options_pressed")
	$Credits.connect("pressed", self, "_on_credits_pressed")
	$Quit.connect("pressed", self, "_on_quit_pressed")
	
	$Continue.disabled = not Cache.has_cache()


func _on_start_pressed():
	if Cache.has_cache():
		var dialog = UI.ask_confirmation("Are you sure you want to start ALL OVER?\n NOTE: You DO have a save.")
		var confirmed = yield(dialog, "answered")
		
		if confirmed:
			# Start a new game
			SceneManager.change_scene_from_button($Start)
		else:
			print("Not doing anything actually")

	else:
		# we do not have cache
		SceneManager.change_scene_from_button($Start)
	


func _on_continue_pressed():
	SceneManager.change_scene_from_button($Continue)


func _on_saves_pressed():
	SceneManager.change_scene_from_button($Saves)


func _on_options_pressed():
	SceneManager.change_scene_from_button($Options)


func _on_credits_pressed():
	SceneManager.change_scene_from_button($Credits)


func _on_quit_pressed():
	var dialog = UI.ask_confirmation("Are you sure you want to quit?")
	var confirmed = yield(dialog, "answered")
	get_tree().quit()












