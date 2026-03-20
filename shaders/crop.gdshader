shader_type canvas_item;

uniform vec2 lower_limit;
uniform vec2 upper_limit = vec2(16, 16);
varying vec2 size;

void fragment() {
	size = 1.0 / TEXTURE_PIXEL_SIZE;
	vec2 lower_limit_mod = lower_limit / size;
	vec2 upper_limit_mod = upper_limit / size;
	if (!(UV.x < upper_limit_mod.x && UV.x > lower_limit_mod.x)) {
		if (UV.y < upper_limit_mod.y && UV.y > lower_limit_mod.y) {
			COLOR = vec4(0);
		}
		else {
			COLOR = texture(TEXTURE, UV);
		}
	} else {
		COLOR = texture(TEXTURE, UV);
	}
}
