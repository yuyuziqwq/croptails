class_name TileMapLayerDataResource
extends NodeDataResource

# 记录地块层已使用的格子和地形配置。
@export var tilemap_layer_used_cells: Array[Vector2i]
@export var terrain_set: int = 0
@export var terrain: int = 3

# 保存 TileMapLayer 当前的格子数据。
func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	var tilemap_layer: TileMapLayer = node as TileMapLayer
	var cells: Array[Vector2i] = tilemap_layer.get_used_cells()
	
	tilemap_layer_used_cells = cells
	
# 按保存的格子列表恢复地形连接。
func _load_data(window: Window) -> void:
	var scene_node = window.get_node_or_null(node_path)
	
	if scene_node != null:
		var tilemap_layer: TileMapLayer = scene_node as TileMapLayer
		tilemap_layer.set_cells_terrain_connect(tilemap_layer_used_cells, terrain_set, terrain, true)
