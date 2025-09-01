shader_type canvas_item;

uniform vec4 color : source_color = vec4(1,1,1,1);
uniform vec4 change_only_with_this_color : source_color = vec4(1,1,1,1);
uniform vec4 change_this_color : source_color = vec4(0.05,0.05,0.05,1);
uniform vec4 change_to_this : source_color = vec4(0.0,0.0,0.0,1);

void fragment() {
	if (abs(COLOR.r -change_this_color.r) < 0.01 && abs(COLOR.b-change_this_color.b) < 0.01 && abs(COLOR.g-change_this_color.g) < 0.01){
		if (change_to_this.r > 0.0 && change_this_color.b > 0.0 && change_this_color.g > 0.0){
			if (abs(color.r-change_only_with_this_color.r)<0.01 && abs(color.b-change_only_with_this_color.b)<0.01 && abs(color.g-change_only_with_this_color.g)<0.01){
				COLOR = change_to_this;
				}
			else{
				COLOR = color+0.26;
			}
			}
		else{
			COLOR = color+0.26;
			}
	}
	else if (abs(COLOR.r-COLOR.b) < 0.001 && COLOR.r > 0.2 && COLOR.b > 0.2 && COLOR.g > 0.2 && abs(COLOR.r-0.02) > 0.01 && abs(COLOR.b-0.02) > 0.01 && abs(COLOR.g-0.02) > 0.01){
		COLOR = color*COLOR;
		}
	else if (abs(COLOR.r-0.01) < 0.01 && abs(COLOR.b-0.01) < 0.01 && abs(COLOR.g-0.01) < 0.01){
		COLOR = color+0.5;
	}
	else if (COLOR.a > 0.6 && COLOR.r > 0.1){
		COLOR = vec4(0,0,0,1);
	}
}
