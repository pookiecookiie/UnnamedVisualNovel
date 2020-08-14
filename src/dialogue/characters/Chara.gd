extends Control


export(Texture) var texture : Texture

func _ready():
	if not $TextureRect.texture:
		set_texture(texture)
	

func set_texture(_texture):
	$TextureRect.texture = _texture
