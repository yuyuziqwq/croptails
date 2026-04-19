extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scenes/objects/trees/log.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)
	
	# 设置工具为 AxeWood（斧头砍树）
	hurt_component.tool = DataTypes.Tools.AxeWood
	
#检测到收到伤害调用的函数
func on_hurt(hit_damage: int) -> void:	
	damage_component.apply_damage(hit_damage)
	#设置材质的shader的参数“shake_inrensity”（摇晃幅度）
	material.set_shader_parameter("shake_inrensity",0.5)
	#创建一个临时计时器
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_inrensity",0.0)
	

func on_max_damage_reached() -> void:
	# 现在先不要马上执行 add_log_scene(),等当前流程跑完,稍后再由 Godot 调用它  
	call_deferred("add_log_scene")
	print("The max damage of small tree reached")
	queue_free()

func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
