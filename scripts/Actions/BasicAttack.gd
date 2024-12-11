extends  Card
class_name BasicAttack

@export var difficulty: int
@export var damage: int

# returns true if dmg dealt
func action(source: Fighter, target: Fighter, _deck: Array, _index: int) -> bool:
	var formatter = getFormatter(source, target)
	
	if (Dice.attack() >= difficulty):
		target.take_wounds(damage, success_msg.format(formatter))
		return true
	else:
		print(fail_msg.format(formatter))
		return false
