extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	#玩家的collision_layer == 2（后续简称layer）,collision_mask == 1（后续简称mask）
	#layer相当于告诉引擎我是谁，mask是告诉引擎我需要和谁产生碰撞，由于walls的mask都是1，所以玩家无法通过walls
	#此处设置door的collisionShape2D 的layer = 1，这样由于玩家的mask == 1，所以会阻挡玩家
	collision_layer = 1
	
func on_interactable_activated() -> void:
	animated_sprite_2d.play("open_door")
	print("activated")
	#玩家的mask == 1，设置为2之后，玩家mask ！= door的layer，所以两者的碰撞消失
	collision_layer = 2

func on_interactable_deactivated() -> void:
	animated_sprite_2d.play("close_door")
	collision_layer = 1
	print("deactivated")
