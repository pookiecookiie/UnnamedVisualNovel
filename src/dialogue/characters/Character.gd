extends Resource

export var display_name: String
export (String, MULTILINE) var backstory: String
export (AtlasTexture) var sprite_sheet: AtlasTexture
export var emotions: Dictionary = {
	# Specific
	"blushing": Resource,
	"shocked": Resource,
	"neutral": Resource,
	"happy": Resource,
	"that_face": Resource,
	"excited": Resource,
	"confused": Resource,
	"sad": Resource,
	"angry": Resource
	
}
