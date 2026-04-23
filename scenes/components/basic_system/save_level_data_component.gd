class_name SaveLevelDataComponent
extends Node

# 当前关卡名会参与生成存档文件名。
var level_scene_name: String
var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource

# 注册到关卡保存分组并缓存关卡名。
func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name

# 收集场景内所有可保存节点的数据。
func save_node_data() -> void:
	# 从分组里获取所有保存组件。
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	
	# 每次保存前重新创建关卡存档资源。
	game_data_resource = SaveGameDataResource.new()
	
	# 保存资源副本，避免把模板资源直接写进存档。
	if nodes != null:
		for node in nodes:
			if node is SaveDataComponent:
				var save_data_resource: NodeDataResource = node.save_data()
				var save_final_resource: NodeDataResource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)
				
# 将当前关卡数据写入用户目录。
func save_game() -> void:
	# 不存在存档目录时先创建目录。
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)
	# 关卡名会拼进最终的存档文件名。
	var level_save_file_name: String = save_file_name % level_scene_name
	
	# 先收集节点数据，再序列化到文件。
	save_node_data()
	
	var result: int = ResourceSaver.save(game_data_resource,save_game_data_path + level_save_file_name)
	print("Save result:", result)
	
# 从用户目录读取当前关卡存档。
func load_game() -> void:
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_game_data_path + level_save_file_name
	
	if !FileAccess.file_exists(save_game_path):
		return
	
	game_data_resource = ResourceLoader.load(save_game_path)
	
	if game_data_resource == null:
		return
	
	# 根窗口用于按节点路径恢复场景对象。
	var root_node: Window = get_tree().root
	
	for resource in game_data_resource.save_data_nodes:
		if resource is Resource:
			if resource is NodeDataResource:
				resource._load_data(root_node)
