extends Node

func roll(sides: int) -> int:
	return randi() % sides + 1

func attack() -> int:
	return roll(6)

const DEATH_CHECK_DC: int = 8
