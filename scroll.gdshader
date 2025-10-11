shader_type canvas_item;

uniform sampler2D source : hint_default_white;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
    vec2 tile_uv = UV;
	tile_uv.y += TIME * 0.6;

    vec2 tile_id = floor(tile_uv);
    vec2 local_uv = fract(tile_uv);

    float rnd_h = hash(tile_id);
    float rnd_v = hash(tile_id + 17.13);
    float rnd_off = hash(tile_id + 91.7);

    if (rnd_h < 0.5) local_uv.x = 1.0 - local_uv.x;
    //if (rnd_v < 0.5) local_uv.y = 1.0 - local_uv.y;

    // vec2 offset = vec2(rnd_off - 0.5) * 1.0;
    // local_uv += offset;
    // local_uv = fract(local_uv);

    COLOR = texture(source, local_uv);
}