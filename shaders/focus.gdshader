shader_type canvas_item;

uniform vec2 focus_position;
uniform float focus_size;
uniform vec4 focus_color: source_color;
varying vec2 size;
varying vec2 start;
varying vec2 end;

void fragment() {
	size = 1.0 / TEXTURE_PIXEL_SIZE;
	start = (focus_position + vec2(-focus_size, focus_size)) / size;
	end = (focus_position + vec2(focus_size, -focus_size)) / size;
	if (UV.x > start.x && UV.y > start.y) {
		if (UV.x < end.x && UV.y < end.y) {
			COLOR = vec4(1, 0, 0, 1);
		}
	}
}
