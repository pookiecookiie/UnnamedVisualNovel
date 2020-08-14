extends Node

var backgrounds: Dictionary = {}
var props: Dictionary = {}
var characters: Dictionary = {}
var dialogs: Dictionary = {}
var fonts: Dictionary = {}


func _ready():
	initialize()


func initialize():
	backgrounds = load_all_from("res://src/dialogue/backgrounds/", ".webp")
	props = load_all_from("res://src/dialogue/props/", ".tres")
	characters = load_all_from("res://src/dialogue/characters/", ".tres")
	dialogs = load_all_json_from("res://src/dialogue/dialogs/")
	fonts = load_all_from("res://src/dialogue/fonts/", ".tres")
	


func get_background(name: String):
	if not backgrounds.has(name):
		print("Something went wrong when loading background. %s" % name)
		return {}
	return backgrounds[name]


func get_prop(name: String):
	if not props.has(name):
		print("Something went wrong when loading props. %s" % name)
		return {}
	return props[name]


func get_character(name: String, emotion: String=""):
	if not characters.has(name):
		print("Something went wrong when loading characters. %s" % name)
		return {}
	
	if emotion.empty():
		return characters[name]
	
	return characters[name].emotions[emotion]


func get_dialog(name: String):
	if not dialogs.has(name):
		print("Something went wrong when loading dialog. %s" % name)
		return {}
	return dialogs[name]


func get_font(name: String):
	if not fonts.has(name):
		print("Something went wrong when loading a font. %s" % name)
		return {}
	return fonts[name] as DynamicFont



func load_all_from(path: String, extension: String):
	var dir = Directory.new()
	var result: Dictionary = {}
	
	assert(dir.dir_exists(path))
	if not dir.open(path) == OK:
		print("Could not read directory %s" % path)
	
	dir.list_dir_begin()
	var file_name: String
	while true:
		file_name = dir.get_next()
		if file_name == "":
			break
		if not file_name.ends_with(extension):
			continue
		result[file_name.get_basename()] = load(path.plus_file(file_name))
	
	return result


func load_all_json_from(path: String):
	var dir = Directory.new()
	var result: Dictionary = {}
	
	assert(dir.dir_exists(path))
	if not dir.open(path) == OK:
		print("Could not read directory %s" % path)
	
	dir.list_dir_begin()
	var file_name: String
	while true:
		file_name = dir.get_next()
		if file_name == "":
			break
		if not file_name.ends_with(".json"):
			continue
		
		var json_file = File.new()
		var json_path: String = path.plus_file(file_name)
		
		json_file.open(json_path, File.READ)
		result[file_name.get_basename()] = JSON.parse(json_file.get_as_text()).result as Dictionary
		json_file.close()
	
	return result

