extends Node


signal progress_saved()
signal progress_loaded(current_dialog)
signal save_saved()
signal save_loaded(save)


var progress: int = 0 # porcentage, i don't know how to calculate it yet tho
var current_dialog: String = "introduction"
var saves: Array = []


func _ready():
	load_cached_data()

func _exit_tree():
	cache_data()


func update_save(new_save):
	self.saves[new_save.index] = new_save

func store_save(save: Dictionary):
	if save.index < 0:
		print("Ignoring -1")
		return
	
	print("Stored save %s" % save)
	self.saves.append(save)


func remove_save(index: int):
	self.saves.remove(index)


func load_save(index: int):
	if index < 0:
		print("Trying to load invalid save.")
		return
	
	print("Loaded Save %s" % index)
	return saves[index]


func cache_data():
	Cache.store("current_dialog", current_dialog)
	Cache.store("saves", saves)


func load_cached_data():
	if Cache.cache.has("current_dialog") and Cache.cache.has("saves"):
		current_dialog = Cache.cache.current_dialog
		saves = Cache.cache.saves

