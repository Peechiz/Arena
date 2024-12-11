extends Node
class_name FightManager

@export var fighters: Array[Fighter]

var winner: Fighter
var fight_deck: Array

var CardUI := preload("res://scenes/cards/Card UI.tscn")
var all_standing: bool:
	get:
		return fighters.all(func(fighter): return !fighter.is_knocked)

func _ready():
	fight_deck = fighters \
		.map(func(fighter): return fighter.deck) \
		.reduce(Util.flat, [])
	fight_deck.sort_custom(func(_a, _b): return randf() > 0.5)
	layout(fight_deck)
	
	Event.FighterKnocked.connect(set_winner)
	print("fight deck: ", fight_deck.map(func(card: Card): return card.cardname))

func get_opponent(card: Card):
	return fighters[0] if fighters[1] == card.owner else fighters[1]

func set_winner(loser: Fighter):
	winner = fighters[0] if loser == fighters[1] else fighters[1]
	Util.yell(winner.fighter_name + " WINS")

func layout(cards: Array) -> void:
	var total_cards := cards.size()
	var card_width := 150  # Width of each card
	var spacing := 50  # Space between cards

	# Calculate the total width required for all cards and spacing
	var total_width = (card_width * total_cards) + (spacing * (total_cards - 1))

	# Calculate the starting X position to center the cards
	var start_x = (get_viewport().size.x - total_width) / 2

	# Position each card
	for i in range(total_cards):
		var card = cards[i]
		card.global_position.x = start_x + (i * (card_width + spacing))
		card.global_position.y = (get_viewport().size.y - 250) / 2  # Center vertically

func start_fight() -> void:
	Util.yell("FIGHT BEGINS!")

	var count := 0
	for index in range(fight_deck.size()):
		var card = fight_deck[index]
		if !winner:
			count += 1
			print("\n", count, ".")
			var source: Fighter = card.owner
			var target: Fighter = get_opponent(card)
			var damage_dealt: bool = card.action(source, target, fight_deck, index)
			
			if damage_dealt:
				print()
				for fighter in fighters:
					debug_fighter_state(fighter)
	print()
	if !winner:
		Util.yell("TIE!")
	#print(fighters[0].fighter_name, ": ", fighters[0].total_wounds())
	#print(fighters[1].fighter_name, ": ", fighters[1].total_wounds())


func _on_button_pressed():
	start_fight()

func debug_fighter_state(fighter: Fighter) -> void:
	print(fighter.fighter_name, ": ", fighter.total_wounds(), " wounds - ",
		"standing: " if not fighter.is_knocked else "fallen: ",
		"alive" if not fighter.is_dead else "dead")
		
	
