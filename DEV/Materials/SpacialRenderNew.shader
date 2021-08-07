shader_type spatial;
render_mode diffuse_burley, specular_blinn;

// Custom
uniform sampler2D texture_plaque : hint_albedo;
uniform sampler2D texture_base_gradient : hint_white;
uniform sampler2D texture_pattern : hint_albedo;
uniform sampler2D texture_pattern_gradient : hint_albedo;
uniform int paint_strips : hint_range(1,6);
uniform float pattern_scale;



void fragment() {
	vec2 base_uv = UV;
	vec2 patt_uv = UV2;
	vec4 albedo_tex = texture(texture_plaque, base_uv);
	vec4 pattern_tex = texture(texture_pattern, patt_uv * pattern_scale);
	vec3 pattern_lut = texture(texture_pattern_gradient, vec2(pattern_tex.g, -abs(NORMAL.z))).rgb;
	ROUGHNESS = pattern_tex.a;
	SPECULAR = pattern_tex.a;
	if (pattern_tex.a > 0.05){
		ALBEDO = mix(pattern_lut, albedo_tex.rgb, -pattern_tex.a);
	}
	else{
		ALBEDO = albedo_tex.rgb;
	}
}
