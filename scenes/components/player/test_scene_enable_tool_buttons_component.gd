extends Node
#该脚本用于解除工具栏被锁定的状态

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("enable_tool_buttons")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func enable_tool_buttons() -> void:
	ToolManager.enable_tool_button(DataTypes.Tools.TillGround)
	ToolManager.enable_tool_button(DataTypes.Tools.WaterCrops)
	ToolManager.enable_tool_button(DataTypes.Tools.PlantCron)
	ToolManager.enable_tool_button(DataTypes.Tools.PlantTomato)
