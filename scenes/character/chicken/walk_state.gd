extends NodeState

@export var character: NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D
@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

var speed: float

# 连接导航避让后的安全速度回调。
func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)

#------------- 进入 Walk 后再生成首个随机点
# 等导航地图同步完成后，再生成本轮首个目标点。
func prepare_movement_target() -> void:
	await get_tree().physics_frame
	#这个状态本身还在不在  
	if !is_active:
		return
	set_movement_target()

#------------- 先校验导航地图有效再取随机点
# 从当前导航地图中抽取一个新的随机可走点。
func set_movement_target() -> void:
	var navigation_map: RID = navigation_agent_2d.get_navigation_map()
	if !navigation_map.is_valid():
		return

	var target_position: Vector2 = NavigationServer2D.map_get_random_point(
		navigation_map,
		navigation_agent_2d.navigation_layers,
		false
	)
	navigation_agent_2d.target_position = target_position
	speed = randf_range(min_speed, max_speed)

func _on_process(_delta: float) -> void:
	pass

# 处理小鸡沿导航路径移动。
func _on_physics_process(_delta: float) -> void:
	# 导航结束后生成下一个目标点。
	if navigation_agent_2d.is_navigation_finished():
		character.current_walk_cycle += 1
		#------------- 到达本轮上限时直接结束，避免提前算出下一轮首点
		if character.current_walk_cycle >= character.walk_cycles:
			return
		set_movement_target()
		return

	# 获取路径上的下一个拐点并计算朝向。
	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var target_direction: Vector2 = character.global_position.direction_to(target_position)
	animated_sprite_2d.flip_h = target_direction.x < 0
	var velocity: Vector2 = target_direction * speed

	# 开启避让时交给 NavigationAgent2D 计算安全速度。
	if navigation_agent_2d.avoidance_enabled:
		animated_sprite_2d.flip_h = velocity.x < 0
		navigation_agent_2d.velocity = velocity
	else:
		character.velocity = velocity
		character.move_and_slide()

# 应用避让系统返回的安全速度。
func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	animated_sprite_2d.flip_h = safe_velocity.x < 0
	character.velocity = safe_velocity
	character.move_and_slide()

# 满足步数后切回 Idle。
func _on_next_transitions() -> void:
	if character.current_walk_cycle >= character.walk_cycles:
		character.velocity = Vector2.ZERO
		transition.emit("Idle")

#------------- 进入状态时重置步数并请求首个目标点
# 进入 Walk 时开始播放移动动画。
func _on_enter() -> void:
	is_active = true
	animated_sprite_2d.play("walk")
	character.current_walk_cycle = 0
	character.roll_walk_cycles()
	prepare_movement_target()

#------------- 退出状态时清掉挂起的目标点
# 离开 Walk 时停止移动动画。
func _on_exit() -> void:
	is_active = false
	navigation_agent_2d.target_position = character.global_position
	animated_sprite_2d.stop()
