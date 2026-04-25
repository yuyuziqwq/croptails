extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emoted_idle_timer: Timer = $EmotedIdleTimer

var idle_emotes: Array =[
	"emote_idle",
	"emote_smile",
	"emote_ear_wave",
	"emote_blink"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play(idle_emotes[0])

func play_emote(animation: String) -> void:
	animated_sprite_2d.play(animation)


func _on_emoted_idle_timer_timeout() -> void:
	var index = randi_range(0,3)
	var emote = idle_emotes[index]
	
	animated_sprite_2d.play(emote)
