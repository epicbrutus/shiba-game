shader_type canvas_item;

uniform float scroll_speed = 0.5;

void fragment() {
	vec2 scrolled_uv = UV;
    scrolled_uv.y += TIME * scroll_speed;
    
    float repeat_index = floor(scrolled_uv.y);
    
    scrolled_uv.y = fract(scrolled_uv.y);
    
    if (mod(repeat_index, 2.0) == 1.0) {
        scrolled_uv.y = 1.0 - scrolled_uv.y;
    }
    
    COLOR = texture(TEXTURE, scrolled_uv);	
}
