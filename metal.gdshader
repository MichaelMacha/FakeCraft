shader_type spatial;

uniform sampler2D heat_noise;
uniform sampler2D heat_color_gradient;
uniform sampler2D heat_stress_map : hint_default_black;
uniform float heat_bias : hint_range(0.0, 0.999) = 0.2;
uniform float heat : hint_range(0.0, 0.999) = 0.0;
uniform float glow_intensity = 4.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0.8, 0.8, 0.8);
	METALLIC = 1.0;
	ROUGHNESS = 0.25;
	
	float glow = (texture(heat_noise, UV.xy).r + heat_bias) * heat;
	glow *= texture(heat_stress_map, UV.xy).r;
	//float glow = heat;
	//EMISSION = vec3(glow);
	EMISSION = texture(heat_color_gradient, vec2(heat)).rgb * glow_intensity * glow;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
