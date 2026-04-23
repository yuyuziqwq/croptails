class_name NodeDataResource
extends Resource

# 记录节点的坐标和层级路径。
@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath

# 保存节点通用数据。
func _save_data(node: Node2D) -> void:
	global_position = node.global_position
	node_path = node.get_path()
	
	var parent_node = node.get_parent()

	if parent_node_path != null:
		parent_node_path = parent_node.get_path()
		
# 留给子类实现具体的加载逻辑。
func _load_data(window: Window) -> void:
	pass
