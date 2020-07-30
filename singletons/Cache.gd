extends Node

# CACHE data is stored here and updated dynamically
var cache = {}

signal stored(data, key)
signal saved(data, key)
signal cache_saved(data)
signal cache_loaded(data)

# Debug
signal error(message, from)
signal warn(message, from)
signal info(message, from)
signal success(message, from)

func _ready():
	connect("stored", self, "_on_data_stored")
	connect("saved", self, "_on_data_saved")
	connect("cache_saved", self, "_on_cache_saved")
	connect("cache_loaded", self, "_on_cache_loaded")
	
	# Debug
	connect("error", Debug, "_on_error")
	connect("warn", Debug, "_on_warn")
	connect("info", Debug, "_on_info")
	connect("success", Debug, "_on_success")
	
	# Read from the cache file
	cache = load_cache()


func _exit_tree():
	# Save to the cache file
	save_cache()


func _on_data_stored(data, key):
	emit_signal("info", "Data SAVED\nKey: " + str(key) + "\nData: " + str(data), "Cache")


func _on_data_saved(data, key):
	emit_signal("info", "Data LOADED\nKey: " + str(key) + "\nData: " + str(data), "Cache")


func _on_cache_saved(data):
	emit_signal("info", "Cache SAVED\nCache: " + str(cache), "Cache")


func _on_cache_loaded(data):
	emit_signal("info", "Cache LOADED\nCache: " + str(cache), "Cache")


func store(key, data:Dictionary):
	cache[key] = data
	
	emit_signal("stored", data, key)


func save_cache():
	if !cache:
		emit_signal("error", "Couldn't save cache", "Cache")
		return
	
	var cache_file = File.new()
	cache_file.open("user://cache.save", File.WRITE)
	cache_file.store_line(to_json(cache))
	cache_file.close()
	
	emit_signal("cache_saved", cache)


func load_cache():
	var cached_data = {}
	var cache_file = File.new()
	if not cache_file.file_exists("user://cache.save"):
		emit_signal("warn", "No Cache file found", "Cache")
		return cached_data # We don't have a save to load.
	
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	cache_file.open("user://cache.save", File.READ)
	while cache_file.get_position() < cache_file.get_len():
		# Get the saved dictionary from the next line in the save file
		cached_data = parse_json(cache_file.get_line())
	cache_file.close()
	
	if !cached_data:
		# If for some reason Null gets saved to the cache
		# just make it an empty object
		cached_data = {}
	
	emit_signal("cache_loaded", cached_data)
	return cached_data
