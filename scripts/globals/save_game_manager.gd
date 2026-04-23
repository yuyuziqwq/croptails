extends Node

# 监听全局保存输入。
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()

# 转发当前场景的保存请求。
func save_game() -> void:
	# 从分组里找到关卡级保存组件。
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	# 只有存在保存组件时才执行保存。
	if save_level_data_component != null:
		save_level_data_component.save_game()

# 转发当前场景的加载请求。
func load_game() -> void:
	# 从分组里找到关卡级保存组件。
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	# 只有存在保存组件时才执行加载。
	if save_level_data_component != null:
		save_level_data_component.load_game()
