extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

#树的美术资源
var log_scene = preload("res://scenes/objects/trees/log.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#如果收到了伤害的信号，连接on_hurt函数
	hurt_component.hurt.connect(on_hurt)
	#再damagecomponent中check累计伤害，如果达到了最大伤害，
	#发送max_damaged_reached连接调用on_max_damage_reached函数
	damage_component.max_damaged_reached.connect(on_max_damage_reached)
	
	# 设置工具为 AxeWood（斧头砍树）
	hurt_component.tool = DataTypes.Tools.AxeWood

func on_hurt(hit_damage: int) -> void:
	#提供伤害
	print("树收到伤害: ", hit_damage, " 当前累积: ", damage_component.current_damage)
	damage_component.apply_damage(hit_damage)
	
	material.set_shader_parameter("shake_inrensity",1.0)
	#创建一个临时计时器
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_inrensity",0.0)
	
	

func on_max_damage_reached() -> void:
	call_deferred("add_log_scene")
	print("The max damage of big tree reached")
	queue_free()

func add_log_scene() -> void:
	#实例化log场景
	var log_instance = log_scene.instantiate()
	#并将其位置设置为当前树的位置
	log_instance.global_position = global_position
	#然后添加到父节点中
	get_parent().add_child(log_instance)
