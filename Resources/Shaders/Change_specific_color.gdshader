shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.05,0.05,0.05,1);
uniform vec4 change_this : source_color = vec4(0.0,0.0,0.0,1);

void fragment() {
	if (abs(COLOR.r-change_this.r) < 0.55 && abs(COLOR.b-change_this.b) < 0.55 && abs(COLOR.g-change_this.g) < 0.55){
		COLOR = color;
	}
}
