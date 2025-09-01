shader_type canvas_item;

uniform bool activated = false;
uniform bool different_style = false;

void fragment() {
	if (activated){
		if (!different_style){
			COLOR.b = COLOR.g;
			COLOR.r = COLOR.g;
			}
		else{
			COLOR.r = COLOR.b;
			COLOR.g = COLOR.b;
		}
	}
}
