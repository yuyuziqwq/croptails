extends NodeState

@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D

#设置状态切换时间间隔
@export var idle_state_time_interval: float = 3.0

#设置状态定时器
@onready var idle_state_timer: Timer = Timer.new()

#该变量用于记录计时器是否跑完时间
var idle_state_timeout: bool = false

func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	#一定记得把生成的组件加到场景树里面，否则计时器不会实际跑起来
	add_child(idle_state_timer)

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	pass

func _on_next_transitions() -> void:
	if idle_state_timeout:	
		transition.emit("Walk")

# 状态机进入该状态时调用。
func _on_enter() -> void:
	animated_sprite_2d.play("idle")
	
	#重置计时器，重新开始
	idle_state_timeout = false
	idle_state_timer.start()

# 状态机退出该状态时调用。
func _on_exit() -> void:
	animated_sprite_2d.stop()
	idle_state_timer.stop()
	
func on_idle_state_timeout() -> void:
	idle_state_timeout = true
