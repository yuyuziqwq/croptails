class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent
#调用全局变量globals中的data_types,并且设置当前的状态
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_seleted)
	
func on_tool_seleted(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
