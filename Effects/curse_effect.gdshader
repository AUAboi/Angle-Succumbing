shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.r = 0.2; 
	COLOR.g = 0.2; 
	COLOR.b = 0.2;
}