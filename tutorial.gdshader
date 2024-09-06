shader_type spatial;

uniform sampler2D noise;
uniform sampler2D noise_normal;
uniform float magnitude = 0.1;

varying vec2 tex_position;

void vertex() {
	tex_position = UV.xy;
	//VERTEX.y += cos(PI * VERTEX.x) * sin(PI * VERTEX.z);
	VERTEX += texture(noise, tex_position).xyz * NORMAL * magnitude;
	//NORMAL = texture(noise_normal, UV.xy).xyz;
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(tex_position, 1.0);
	NORMAL_MAP = texture(noise_normal, tex_position).xyz;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
