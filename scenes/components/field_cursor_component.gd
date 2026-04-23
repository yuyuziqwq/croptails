class_name FieldCursorComponent
extends Node2D

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 3

@onready var player: Player = get_tree().get_first_node_in_group("player")

#定义可变鼠标位置
var mouse_position: Vector2
#定义单元格位置
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			add_tilled_soil_cell()
			
#获取当前鼠标所在的格子的位置
func get_cell_under_mouse() -> void:
	#鼠标位置等于在这个tilemaplayer上鼠标位置
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	#过鼠标的位置确定tilemap的单元格位置
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	#debug语句
	#print("mouse position :",mouse_position)
	#print("cell position :",cell_position)
	#print("cell source id :",cell_source_id)
	#print("distance :",distance)
	
func add_tilled_soil_cell() -> void:
	if distance < 20.0 && cell_source_id != -1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position],terrain_set,terrain,true)

func remove_tilled_soil_cell() -> void:
	if distance < 20:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position],0,-1,true)
