extends Card

@export var difficulty: int
@export var counter_dc: int = 6
@export var damage: int
@export_multiline var description: String
@export_multiline var counter_msg: String

## a weak Attack followed by a counter attack. returns true if dmg dealt to anyone
func action(source: Fighter, target: Fighter, _deck: Array, _index: int):
	var formatter = getFormatter(source, target)
	print(description.format(formatter))
	
	var damage_dealt := false
	
	if (Dice.attack() >= difficulty):
		target.take_wounds(damage, success_msg.format(formatter))
		damage_dealt = true
	else:
		print(fail_msg.format(formatter))

	if (Dice.attack() >= counter_dc):
		damage_dealt = true
		source.take_wounds(damage, counter_msg.format(formatter))
	return damage_dealt
