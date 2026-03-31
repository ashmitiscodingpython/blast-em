shader_type canvas_item;

uniform sampler2D revealer;
uniform sampler2D noise_tex;
uniform float speed = 0.05;
uniform float density = 0.5;

void fragment() {
    vec2 uv = UV / 4.0;
	uv.x = fract(uv.x + (TIME * speed * 0.005));
    float n = texture(noise_tex, uv).r;
    float fog = smoothstep(0.3, 0.7, n) * density;
    vec3 fog_color = vec3(0.8, 0.8, 0.8);
	fog *= texture(revealer, UV).r;
    COLOR = vec4(fog_color, fog);
}