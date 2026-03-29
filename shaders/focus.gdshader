shader_type canvas_item;

instance uniform float radius = 0.75;
instance uniform float override = 0;
instance uniform bool overriding = false;
uniform vec4 color: source_color;
uniform vec4 background: source_color;
uniform vec2 position;

void fragment() {
	vec2 uv = UV;
    vec2 size = 1.0 / TEXTURE_PIXEL_SIZE;
	uv = uv - (position / size);
	float aspect = size.x / size.y;
	uv.x *= aspect;
	float dist = length(uv);
	COLOR = mix(background, color, smoothstep(0, 1, dist / radius));
	if (overriding) {
		COLOR *= vec4(1, 1, 1, override);
	}
}