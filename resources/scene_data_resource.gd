class_name SceneDataResource
extends NodeDataResource

# 额外记录场景实例化所需的信息。
@export var node_name: String
@export var scene_file_path: String

# 保存场景节点专有的数据。
func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	node_name = node.name
	scene_file_path = node.scene_file_path

# 通过场景路径重新实例化节点。
func _load_data(window: Window) -> void:
	var parent_node: Node2D
	var scene_node: Node2D
	
	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)
		
	if node_path != null:
		var scene_file_resource: Resource = load(scene_file_path)
		scene_node = scene_file_resource.instantiate() as Node2D

	if parent_node != null and scene_node != null:
		scene_node.global_position = global_position
		parent_node.add_child(scene_node)
