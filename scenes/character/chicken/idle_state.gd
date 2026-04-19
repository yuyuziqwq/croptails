extends NodeState

@export var character: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
#开始寻路间隔
@export var idle_state_time_interval: float = 3.0

#设置状态转换前的定时器，到了一定时间之后就会转换状态
@onready var idle_state_timer: Timer = Timer.new()

#改变量用于记录计时器是否跑完时间
var idle_state_timeout: bool = false

func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	#timeout：Timer 节点自带的 信号（Signal）。这里是指当计时器信号连接on_idle_state_timeout函数，计时器时间结束会调用该函数
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	#确保计时器存在于场景中
	add_child(idle_state_timer)

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

#在下一个转换中
func _on_next_transitions() -> void:
	if idle_state_timeout:
		#该处的transition是由于该idle_state是extends继承的NodeState，这是NodeState内定义的信号signal
		transition.emit("Walk")

#当状态机进入该状态
func _on_enter() -> void:
	animated_sprite_2d.play("idle")
	
	#重置计时器，重新开始
	idle_state_timeout = false
	idle_state_timer.start()

#状态机退出该状态
func _on_exit() -> void:
	animated_sprite_2d.stop()
	#停止计时器
	idle_state_timer.stop()
	
func on_idle_state_timeout() -> void:
	idle_state_timeout = true
