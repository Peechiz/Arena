extends Node
class_name  Card

@export var cardname: String
@export_multiline var success_msg: String
@export_multiline var fail_msg: String = "{source} misses {target} with the {atk}"

var CardUI := preload("res://scenes/cards/Card UI.tscn")

func _ready():
	var UI := CardUI.instantiate()
	var label: Label = UI.find_child('Label')
	label.text = cardname
	add_child(UI)

	
# returns success
func action(_source: Fighter, _target: Fighter, _deck: Array, _index: int):
	pass

func getFormatter(source: Fighter, target: Fighter):
	return {"source": source.name, "target": target.name, "atk": cardname}
