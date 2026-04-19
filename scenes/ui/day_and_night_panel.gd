extends Control

@onready var time_label: Label = $PositionControl/TimePanel/MarginContainer/Time_Label
@onready var day_label: Label = $PositionControl/DayPanel/MarginContainer/Day_Label

@export var normal_speed:int = 5
@export var fast_speed: int = 100
@export var cheetah_speed: int =200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DayAndNightCycleManager.time_tick.connect(on_time_tick)

func on_time_tick(day: int, hour: int, minute: int) -> void:
	day_label.text = "Day " + str(day)
	time_label.text = "%02d:%02d" % [hour, minute]
	


func _on_normal_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = normal_speed


func _on_fast_speed_button_2_pressed() -> void:
	DayAndNightCycleManager.game_speed = fast_speed


func _on_cheetah_speed_button_3_pressed() -> void:
	DayAndNightCycleManager.game_speed = cheetah_speed
