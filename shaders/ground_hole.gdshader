shader_type spatial;
render_mode cull_back;

uniform vec3 hole_pos = vec3(0.0);
uniform float hole_radius = 1.25;
uniform vec3 ground_color : source_color = vec3(0.32, 0.68, 0.38);

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float dist = length(world_pos.xz - hole_pos.xz);
	if (dist < hole_radius) {
		discard;
	}
	ALBEDO = ground_color;
	ROUGHNESS = 0.85;
}
