shader_type spatial;
render_mode cull_back;

uniform vec3 hole_pos = vec3(0.0);
uniform float hole_radius = 1.25;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, hint_default_white;
uniform vec3 ground_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float roughness : hint_range(0.0, 1.0) = 0.8;

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float dist = length(world_pos.xz - hole_pos.xz);
	if (dist < hole_radius) {
		discard;
	}
	vec4 tex_color = texture(texture_albedo, UV);
	ALBEDO = tex_color.rgb * ground_color;
	ROUGHNESS = roughness;
}
