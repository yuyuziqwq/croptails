class_name NonPlayableCharacter
extends CharacterBody2D

@export var min_walk_cycle: int = 1
@export var max_walk_cycle: int = 4

var walk_cycles: int
var current_walk_cycle: int

#------------- 统一在每次进入行走时重新随机步数
func roll_walk_cycles() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
