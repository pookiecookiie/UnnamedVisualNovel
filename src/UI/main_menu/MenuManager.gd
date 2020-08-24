extends VBoxContainer


onready var MainMenu = load("res://src/UI/main_menu/MainMenu.tscn")
onready var Options = load("res://src/UI/Options/Options.tscn")
onready var Credits = load("res://src/UI/Credits/Credits.tscn")

onready var Introduction = load("res://src/dialogue/Dialog.tscn")



func _ready():
	$Start.connect("pressed", self, "_on_start_pressed")
	$Continue.connect("pressed", self, "_on_continue_pressed")
	$Options.connect("pressed", self, "_on_options_pressed")
	$Credits.connect("pressed", self, "_on_credits_pressed")
	$Quit.connect("pressed", self, "_on_quit_pressed")
	
	$Continue.disabled = not Cache.has_progress()


func _on_start_pressed():
	if Cache.has_progress():
		var dialog = UI.ask_confirmation("Are you sure you want to start ALL OVER?\n NOTE: You DO have progress.")
		var confirmed = yield(dialog, "answered")
		
		if confirmed:
			ProgressManager.start()
			# Start a new game
			SceneManager.change_scene_from_button($Start)
		else:
			# Don't add this to the progress manager...
			return
	else:
		ProgressManager.start()
		# we do not have cache, so it's ok.
		SceneManager.change_scene_from_button($Start)
	
	


func _on_continue_pressed():
	SceneManager.change_scene_from_button($Continue)


func _on_options_pressed():
	SceneManager.change_scene_from_button($Options)


func _on_credits_pressed():
	SceneManager.change_scene_from_button($Credits)


func _on_quit_pressed():
	var dialog = UI.ask_confirmation("Are you sure you want to quit?")
	var confirmed = yield(dialog, "answered")
	get_tree().quit()












