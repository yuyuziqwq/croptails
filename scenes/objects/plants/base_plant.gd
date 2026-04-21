extends Node2D

@onready var plant_sprite_2d: Sprite2D = $PlantSprite2D
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var watering_component: HurtComponent = $WateringComponent
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

@export var plant_texture: Texture2D:
	set(value):
		plant_texture = value
		if plant_sprite_2d:
			plant_sprite_2d.texture = value
@export var flowering_particles_texture: Texture2D:
	set(value):
		flowering_particles_texture = value
		if flowering_particles:
			flowering_particles.texture = value
@export var watering_particles_texture: Texture2D:
	set(value):
		watering_particles_texture = value
		if watering_particles:
			watering_particles.texture = value
@export var sprite_hframes: int:
	set(value):
		sprite_hframes = value
		if plant_sprite_2d:
			plant_sprite_2d.hframes = value
@export var sprite_vframes: int:
	set(value):
		sprite_vframes = value
		if plant_sprite_2d:
			plant_sprite_2d.vframes = value
@export var sprite_frame_coords: Vector2i:
	set(value):
		sprite_frame_coords = value
		if plant_sprite_2d:
			plant_sprite_2d.frame_coords = value

@export var crop_harvest_scene: PackedScene  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_apply_visual_config()
	flowering_particles.emitting = false
	watering_particles.emitting = false
	
	#连接浇水组件，让浇水对作物造成伤害
	watering_component.hurt.connect(on_watering)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)
	
#负责“节点准备好后兜底初始化” 
func _apply_visual_config() -> void:                                                                                          
	plant_sprite_2d.texture = plant_texture                                                                                 
	plant_sprite_2d.hframes = sprite_hframes                                                                                
	plant_sprite_2d.vframes = sprite_vframes                                                                         
	plant_sprite_2d.frame_coords = sprite_frame_coords                                                                      
	flowering_particles.texture = flowering_particles_texture                                                               
	watering_particles.texture = watering_particles_texture 	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	plant_sprite_2d.frame = growth_state
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true
	
#浇水函数
func on_watering(hit_damage: int) -> void:
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		#创造计时器，让浇水粒子出现3秒
		await get_tree().create_timer(3.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true

#成熟函数，用于开启成熟特效	
func on_crop_maturity() -> void:
	flowering_particles.emitting = true

#收获状态函数，生成可拾取的农产品
func on_crop_harvesting() -> void:
	var crop_harvest_instance = crop_harvest_scene.instantiate() as Node2D
	crop_harvest_instance.global_position = global_position
	get_parent().add_child(crop_harvest_instance)
	queue_free()
