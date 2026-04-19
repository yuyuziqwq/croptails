shader_type canvas_item;

//次函数用于控制该树的摇晃shader，uniform可以让参数在编辑器内可以设置
//摇晃强度
uniform float shake_inrensity = 0;
//摇晃速度
uniform float shake_speed = 20.0;

void vertex() {
	// Called for every vertex the material is visible on.
	vec2 shake = vec2(0.0);

	// 检查顶点y 是否小于0
	if(VERTEX.y < 0.0) {
		//时间乘以摇动速度加上顶点y乘以摇晃强度
		shake.x = sin(TIME * shake_speed + VERTEX.y) * shake_inrensity;

		VERTEX.xy += shake;
	} 
}
