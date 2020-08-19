extends Node

# CACHE data is stored here and updated dynamically
var cache = {}

signal stored(data, key)
signal saved(data, key)
signal cache_saved(data)
signal cache_loaded(data)

func _ready():
	connect("stored", self, "_on_data_stored")
	connect("saved", self, "_on_data_saved")
	connect("cache_saved", self, "_on_cache_saved")
	connect("cache_loaded", self, "_on_cache_loaded")

	
	# Read from the cache file
	cache = load_cache()


func _exit_tree():
	# Save to the cache file
	save_cache()


func _on_data_stored(data, key):
	printt("Data stored: %s" % data, "Key: %s" % key)


func _on_data_saved(data, key):
	printt("Data Saved: %s" % data, "Key: %s" % key)


func _on_cache_saved(data):
	printt("Cache saved, Data: %s" % data)


func _on_cache_loaded(data):
	print("Loaded Data: %s" % data)


func has_cache():
	return not cache.empty()

func store(key, data:Dictionary):
	cache[key] = data
	
	emit_signal("stored", data, key)


func save_cache():
	if not cache:
		push_error("Could not save cache, because cache does not exist")
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
		push_warning("No cache file found.")
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
		# Or a broken JSON file
		push_warning("Cache is broken or empty. %s" % str(cached_data))
	emit_signal("cache_loaded", cached_data)
	return cached_data
