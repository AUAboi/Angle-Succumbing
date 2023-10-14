shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.r = 0.1; 
	COLOR.g = 0.1; 
	COLOR.b = 0.1;
}