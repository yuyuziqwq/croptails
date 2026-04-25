extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_corn: Button = $MarginContainer/HBoxContainer/ToolCorn
@onready var tool_tomato: Button = $MarginContainer/HBoxContainer/ToolTomato
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan

func _ready() -> void:
	ToolManager.tool_selected.connect(_on_tool_selected)
	_sync_tool_buttons(ToolManager.selected_tool)
	tool_disabled()
	ToolManager.enable_tool.connect(on_enable_tool_button)
	
#关闭按钮，让按钮无效
func tool_disabled() -> void:	
	tool_tilling.disabled =true
	tool_tilling.focus_mode = Control.FOCUS_NONE
	
	tool_watering_can.disabled =true
	tool_watering_can.focus_mode = Control.FOCUS_NONE
	
	tool_corn.disabled =true
	tool_corn.focus_mode = Control.FOCUS_NONE
	
	tool_tomato.disabled =true
	tool_tomato.focus_mode = Control.FOCUS_NONE
	

func _on_tool_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)

func _on_tool_tilling_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)

func _on_tool_watering_can_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)

func _on_tool_corn_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantCron)

func _on_tool_tomato_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantTomato)

func _on_tool_selected(tool: DataTypes.Tools) -> void:
	_sync_tool_buttons(tool)

#set_pressed_no_signal绑定按钮检查器中BaseButton的toggle Mode（为true）使用
func _sync_tool_buttons(selected_tool: DataTypes.Tools) -> void:
	tool_axe.set_pressed_no_signal(selected_tool == DataTypes.Tools.AxeWood)
	tool_tilling.set_pressed_no_signal(selected_tool == DataTypes.Tools.TillGround)
	tool_watering_can.set_pressed_no_signal(selected_tool == DataTypes.Tools.WaterCrops)
	tool_corn.set_pressed_no_signal(selected_tool == DataTypes.Tools.PlantCron)
	tool_tomato.set_pressed_no_signal(selected_tool == DataTypes.Tools.PlantTomato)

#取消选中
func _unhandled_input(event: InputEvent) -> void:
	# 这里的 release_tool 不是 Godot 内置关键字，而是你在 Input Map 里自己定义的动作名。它可能绑定了某个按键，比如 Esc、Q 之类。
	if event.is_action_pressed("release_tool"):
		ToolManager.select_tool(DataTypes.Tools.None)

func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	if tool == DataTypes.Tools.TillGround:
		tool_tilling.disabled = false
		tool_tilling.focus_mode = Control.FOCUS_ALL
		
	elif tool == DataTypes.Tools.WaterCrops:
		tool_watering_can.disabled = false
		tool_watering_can.focus_mode = Control.FOCUS_ALL
	
	elif tool == DataTypes.Tools.PlantCron:
		tool_corn.disabled = false
		tool_corn.focus_mode = Control.FOCUS_ALL	
	
	elif tool == DataTypes.Tools.PlantTomato:
		tool_tomato.disabled = false
		tool_tomato.focus_mode = Control.FOCUS_ALL
	
	
	
	
