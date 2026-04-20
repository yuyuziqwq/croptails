extends Node2D

var corn_harvest_scene = preload("res://scenes/objects/plants/corn_harvest.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#设置默认状态
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	#连接伤害组件，造成伤害后触发on_hurt函数来改变植物被浇水的状态
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true
	
func on_hurt(hit_damage: int) -> void:
	#如果没有被浇水，则播放粒子播放器
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true
		

func on_crop_maturity() -> void:
	flowering_particles.emitting = true
	
func on_crop_harvesting() -> void:
	var corn_harvest_instance = corn_harvest_scene.instantiate() as Node2D
	corn_harvest_instance.global_position = global_position
	get_parent().add_child(corn_harvest_instance)
	queue_free()
	
	
	
