tool
extends RichTextEffect
class_name RichTextCharacter

var bbcode := "character"

func _process_custom_fx(char_fx):
	var character = char_fx.env.get("name", "Narrator")
	var character_color: Color
	
	# Get the characters color
	for character_obj in Loader.characters.values():
		if character_obj.display_name == character:
			character_color = character_obj.name_color
	
	if not character_color:
		push_error("Seems like no character was found with a given name")
	
	char_fx.color = character_color
	
	return true
