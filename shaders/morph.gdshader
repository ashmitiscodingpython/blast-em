shader_type canvas_item;

uniform sampler2D fadee;
uniform float fade_amount: hint_range(0.0, 1.0);

void fragment() {
	COLOR = mix(texture(fadee, UV), texture(TEXTURE, UV), fade_amount);
}
