extends Sprite2D

@onready var damage_component: DamageComponent = $DamageComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var stone_scene = preload("res://scenes/objects/rocks/Stone.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#父节点接受hurtcomponent的hurt信号
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)


func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_inrensity",1)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_inrensity",0)

func on_max_damage_reached() -> void:
	# 现在先不要马上执行 add_log_scene(),等当前流程跑完,稍后再由 Godot 调用它  
	call_deferred("add_stone_scene")
	print("The max damage of Rock reached")
	queue_free()

func add_stone_scene() -> void:
	#生成stone实例
	var stone_instance = stone_scene.instantiate() as Node2D
	#将rock的位置赋予给stone
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
