class_name SaveDataComponent
extends Node

# 缓存需要被保存的父节点。
@onready var parent_node: Node2D = get_parent() as Node2D

# 指向具体的数据资源实现。
@export var save_data_resource: Resource

# 注册到保存组件分组。
func _ready() -> void:
	add_to_group("save_data_component")

# 将父节点状态写入数据资源。
func save_data() -> Resource:
	if parent_node == null:
		return null
		
	if save_data_resource == null:
		push_error("save_data_resource: ",save_data_resource,parent_node.name)
		return
	
	# 调用资源自身的保存实现。
	save_data_resource._save_data(parent_node)
	
	return save_data_resource
