shader_type canvas_item;

uniform float blue = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
	//VERTEX += vec2(10.0, 0.0);
	// Animate Sprite2D moving in big circle around its location
	//VERTEX += vec2(cos(TIME)*16.0, sin(TIME)*16.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = vec4(0.4, 0.6, 0.9, 1.0);
	//COLOR = vec4(UV, 0.5, 1.0);
	COLOR = texture(TEXTURE, UV);
	COLOR *= vec4(0.5, 0.5, 0.5, 1.0);
	//if (UV[0] > 0.5) {
		//COLOR.b = blue;
	//}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
