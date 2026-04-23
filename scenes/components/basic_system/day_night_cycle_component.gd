class_name DayNightCycleComponent
extends CanvasModulate

@export var initial_day: int = 1:
	#相当于你在Inspector（检查器）上修改了这个export的函数
	#使用该setter方法（设置器）去同步你修改的值
	set(id):
		initial_day = id
		DayAndNightCycleManager.initial_day = id
		DayAndNightCycleManager.set_initial_time()

@export var initial_hour: int = 12:
	set(ih):
		initial_hour = ih
		DayAndNightCycleManager.initial_hour = ih
		DayAndNightCycleManager.set_initial_time()

@export var initial_minute: int = 30:
	set(im):
		initial_minute = im
		DayAndNightCycleManager.initial_minute = im
		DayAndNightCycleManager.set_initial_time()
		
#日夜渐变纹理,使用1d渐变纹理
@export var day_night_gradient_texture: GradientTexture1D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DayAndNightCycleManager.initial_day = initial_day
	DayAndNightCycleManager.initial_hour = initial_hour
	DayAndNightCycleManager.initial_minute = initial_minute
	DayAndNightCycleManager.set_initial_time()
	
	#接受时间控制器的信号signal game_time,该处信号发送变量是游戏内时间
	DayAndNightCycleManager.game_time.connect(on_game_time)
	
func on_game_time(time: float) -> void:
	#该函数可以用ai去画图y = 0.5 · ( sin(x − π/2) + 1 )可以理解，通常又来表示太阳的高度/光照强度
	#当横坐标，也就是time（游戏内时间对应地球自转角度）为0时，太阳高度y为0
	#time为π高度为1，为2π则是0。0，π，2π分别是凌晨，中午和半夜
	#其实就是刚好符合地球自转规律和光照强度
	var sample_value = 0.5 * (sin(time - PI *0.5) + 1.0)
	#在对应的纹理上取点
	color = day_night_gradient_texture.gradient.sample(sample_value)
