extends NodeState

@export var player: Player
@export var animated_spite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

func _ready() -> void:
	#此时刚进入该状态，应该先禁用掉hit的判定框，防止误判（没有播放浇水动作且没有设置浇水区域就判定了）
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2(0, 0)

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animated_spite_2d.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	if player.player_direction == Vector2.UP:
		animated_spite_2d.play("chopping_back")
		hit_component_collision_shape.position = Vector2(0, -18)
	elif player.player_direction == Vector2.DOWN:
		animated_spite_2d.play("chopping_front")
		hit_component_collision_shape.position = Vector2(0, 3)
	elif player.player_direction == Vector2.LEFT:
		animated_spite_2d.play("chopping_left")
		hit_component_collision_shape.position = Vector2(-9, 0)
	elif player.player_direction == Vector2.RIGHT:
		animated_spite_2d.play("chopping_right")
		hit_component_collision_shape.position = Vector2(9, 0)
	else:
		animated_spite_2d.play("chopping_front")
		hit_component_collision_shape.position = Vector2(0, 3)
	
	#此处上方以及播放了对应的浇水动画且给浇水区域设置了位置，应该改为false来打开碰撞区的判定
	hit_component_collision_shape.disabled = false
	
	
func _on_exit() -> void:
	animated_spite_2d.stop()
	#防止hit判定框误判，关闭碰撞
	hit_component_collision_shape.disabled = true
