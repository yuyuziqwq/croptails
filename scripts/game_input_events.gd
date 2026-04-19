class_name GameInputEvents

static var direction: Vector2

#获取输入，并且将输入的方向复制储存到direction参数中
#方便player获取该变量，然后作为自身属性被其他模块访问
static func movement_input() -> Vector2:
	if Input.is_action_pressed("walk_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("walk_down"):
		direction = Vector2.DOWN	
	elif Input.is_action_pressed("walk_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("walk_right"):
			direction = Vector2.RIGHT	
	else:
		direction = Vector2.ZERO
		
	return direction
	
#判断是否有输入，方便玩家做某些判定
static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true

static func use_tool() -> bool:
	var use_tool_value: bool = Input.is_action_just_pressed("hit")
	
	return use_tool_value	
	
