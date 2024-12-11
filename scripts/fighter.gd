extends Node
class_name Fighter

@export var fighter_name: String
@export var hp: int
@export var armor: int = 0

@onready var deck: Array[Node] = get_children().filter(func(child): return child.is_in_group("Card"))

var is_knocked := false # maybe i don't need to store this if I'm sending a signal about it?
var is_dead := false:
	set(dead):
		if dead:
			is_knocked = true
		is_dead = dead
		

func _ready():
	pass
	#print("fighter deck: ", deck)
	#print("is card? ", deck[0].is_in_group("Card"))

var tough: int :
	get:
		return floor(float(hp) / 2) + armor

var wounds = {
	"torso": 0,
	"head": 0,
	"left_arm": 0,
	"right_arm": 0,
	"left_leg": 0,
	"right_leg": 0,
}

func take_wounds(damage: int, message: String) -> void:
	var body_parts = wounds.keys() 
	var random_part = body_parts[randi() % body_parts.size()]
	var formatter = {"part": random_part, "dmg": damage}
	wounds[random_part] += damage
	print(message.format(formatter))
	
	var knocked = check_knocked()
	if knocked:
		Event.FighterKnocked.emit(self)
		var died = check_died()
		if died:
			Event.FighterDied.emit(self)
	
	


func total_wounds() -> int:
	return wounds.values().reduce(func(acc, val): return acc + val, 0)

func check_knocked() -> bool:
	var DC = total_wounds()
	# must beat total wounds to survive, ties lose
	var roll = Dice.roll(hp)
	is_knocked = (roll + tough) <= DC
	print("roll:{roll} + tough:{tough} ({rolltough}) <= {DC} Wounds ? {outcome}".format(
		{ "roll": roll, "tough": tough, "rolltough": roll+tough, "DC": DC, "outcome": ("knocked" if is_knocked else "still standing")}
	))

	return is_knocked
	
func check_died() -> bool:
	if !is_knocked: return false
	
	var overkill = max(total_wounds() - hp, 0)
	var roll =  Dice.roll(Dice.DEATH_CHECK_DC)
	var DC = Dice.DEATH_CHECK_DC - tough + overkill
	print({
		"name": fighter_name,
		"overkill": overkill,
		"roll": roll,
		"DC": DC,
		"dead": roll < DC
	})
	is_dead = roll < DC
	# if you rolled less than the DC, you are dead
	return is_dead
