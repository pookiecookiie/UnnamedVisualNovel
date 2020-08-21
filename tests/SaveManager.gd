extends Node


var saves: Dictionary = {}


func _ready():
	self.load_save()


func _exit_tree():
	# Before we leave, make sure to save
	self.save()


func get_saves():
	return saves


func update_save(new_saves):
	saves = new_saves


func save():
	# Saves the "saves" to the cache
	Cache.store("saves", saves)


func load_save():
	# Loads the "saves" from the cache
	if Cache.cache.has("saves"):
		saves = Cache.cache.saves
	
