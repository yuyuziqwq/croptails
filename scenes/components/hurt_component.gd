class_name HurtComponent
extends Area2D
#继承area2D，一般area2d下方还有一个collisionShape2D
#用于检测物体的接触交互

#导出需要交互的工具类型
@export var tool : DataTypes.Tools = DataTypes.Tools.None

signal hurt

#检测进入的目标
func _on_area_entered(area: Area2D) -> void:
	#类型转换，将接触的模板转换成HitComponent类型，转换类型后对应的参数可以调用该类型的元素（参数，函数等）
	var hit_component = area as HitComponent
	print("now tool: ",hit_component.current_tool)
	
	#如果工具类型正确，那么就会传输HitComponent的伤害信号
	if tool == hit_component.current_tool:
		hurt.emit(hit_component.hit_damage)
