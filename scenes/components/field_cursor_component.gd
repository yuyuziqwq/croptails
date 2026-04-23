class_name FieldCursorComponent
extends Node

# 草地图层用于计算鼠标所在格子。
@export var grass_tilemap_layer: TileMapLayer
# 翻土图层用于写入或清除耕地结果。
@export var tilled_soil_tilemap_layer: TileMapLayer
# 地形集索引决定写入哪组 terrain。
@export var terrain_set: int = 0
# 地形索引决定写入哪种翻土样式。
@export var terrain: int = 3

# 缓存玩家节点用于限制可操作距离。
@onready var player: Player = get_tree().get_first_node_in_group("player")

# 记录鼠标在草地图层中的本地坐标。
var mouse_position: Vector2
# 记录鼠标当前指向的地块坐标。
var cell_position: Vector2i
# 记录该格子在草地图层上的 source id。
var cell_source_id: int
# 记录格子中心对应的本地位置。
var local_cell_position: Vector2
# 记录玩家与目标格子的距离。
var distance: float

# 根据输入在鼠标所在格子上添加或移除翻土。
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			add_tilled_soil_cell()
			
# 获取鼠标当前指向的格子及其相关数据。
func get_cell_under_mouse() -> void:
	# 读取鼠标在草地图层内的本地坐标。
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	# 把鼠标坐标转换成 tilemap 的格子坐标。
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	# 检查该格子在草地图层上是否已有 tile。
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	print("cell_source_id :",cell_source_id)
	# 取回该格子对应的本地中心位置。
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	# 计算玩家与目标格子的距离用于交互限制。
	distance = player.global_position.distance_to(local_cell_position)
	
	# 下面是调试输出，默认保持注释状态。
	#print("mouse position :",mouse_position)
	#print("cell position :",cell_position)
	#print("cell source id :",cell_source_id)
	#print("distance :",distance)
	
# 在目标格子写入翻土 terrain。
func add_tilled_soil_cell() -> void:
	# 只允许翻动玩家附近且草地存在的格子。
	if distance < 20.0 && cell_source_id != -1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position],terrain_set,terrain,true)

# 清除目标格子上的翻土 terrain。
func remove_tilled_soil_cell() -> void:
	# 只允许清除玩家附近的翻土地块。
	if distance < 20:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position],0,-1,true)
