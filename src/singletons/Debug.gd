extends Node

var debug : bool = false


func _on_error(message, from:String="DEBUG"):
	if !debug:
		return
	
	var text : String = ""
	text += "[ERROR] "
	text += from + ": "
	text += message
	print(text)


func _on_warn(message, from:String="DEBUG"):
	if !debug:
		return
	
	var text : String = ""
	text += "[WARN] "
	text += from + ": "
	text += message
	print(text)



func _on_info(message, from:String="DEBUG"):
	if !debug:
		return
	
	var text : String = ""
	text += "[INFO] "
	text += from + ": "
	text += message
	print(text)


func _on_success(message, from:String="DEBUG"):
	if !debug:
		return
	
	var text : String = ""
	text += "[SUCCESS] "
	text += from + ": "
	text += message
	print(text)
