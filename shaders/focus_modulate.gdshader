shader_type canvas_item;

uniform float radius = 0.75;
uniform float strength: hint_range(0.0, 1.0);
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
	COLOR = texture(TEXTURE, UV) * mix(background, color, smoothstep(0, 1, dist / radius)) * strength;
	if (overriding) {
		COLOR *= vec4(1, 1, 1, override);
	}
}
