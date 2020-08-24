extends Node

signal progress_saved(progress)
signal progress_loaded(progress)


# Introduction should be the first dialog the player ever sees, no matter what
var current_dialog: String = ""
var dialog_index: int = 0


func _ready():
	load_cached_data()

func _exit_tree():
	cache_data()


func start():
	current_dialog = "introduction"
	dialog_index = 0


func save_progress(progress):
	current_dialog = progress.current_dialog
	dialog_index = progress.dialog_index


func cache_data():
	if not current_dialog.empty():
		Cache.store("current_dialog", current_dialog)
		Cache.store("dialog_index", dialog_index)
		emit_signal("progress_saved", current_dialog)


func load_cached_data():
	if Cache.cache.has("current_dialog") and Cache.cache.has("dialog_index"):
		current_dialog = Cache.cache.current_dialog
		dialog_index = Cache.cache.dialog_index
		emit_signal("progress_loaded", current_dialog)

