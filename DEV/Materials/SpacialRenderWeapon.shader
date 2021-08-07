shader_type spatial;
render_mode diffuse_burley, specular_blinn;

// Custom
uniform sampler2D texture_cc : hint_albedo;
uniform sampler2D texture_nm : hint_white;
uniform sampler2D texture_base_gradient : hint_black_albedo;
uniform sampler2D texture_pattern : hint_black_albedo;
uniform sampler2D texture_pattern_gradient : hint_black_albedo;
uniform float pattern_scale = 1;
uniform vec2 pattern_offset = vec2(0, 0);



void fragment() {
	vec2 base_uv = UV;
	vec2 patt_uv = UV2;
	vec4 albedo_tex = texture(texture_cc, base_uv);
	vec4 albedo_norm = texture(texture_nm, base_uv);
	
	vec4 pattern_tex = texture(texture_pattern, (patt_uv + pattern_offset) * pattern_scale);
	vec3 pattern_lut = texture(texture_pattern_gradient, vec2(pattern_tex.g, -abs(NORMAL.z))).rgb;
	
	vec4 base_gradient_top4 = texture(texture_base_gradient, vec2(albedo_tex.r, 0.0159));
	vec4 cc_base_color = texture(texture_base_gradient, vec2(albedo_tex.r, -clamp( abs(NORMAL.z), 0.97, 0.0 )));
	
	
	
//	float specular_strength = albedo_tex.a + pattern_tex.a / 2.0;
	float specular_strength = mix(albedo_tex.a, pattern_tex.a, pattern_tex.g);
//	ROUGHNESS = mix(albedo_tex.a, pattern_tex.a, 0.5);
//	ROUGHNESS = -mix(albedo_tex.a, pattern_tex.a, 0.5) + 1.0;
	
//	ROUGHNESS = -specular_strength;
	ROUGHNESS = base_gradient_top4.b;
	
	
	SPECULAR = specular_strength;
	
	
//	vec3 cc_base_color = vec3(1.0, 1.0, 1.0);
	float base_blend_pattern = pattern_tex.r * cc_base_color.a;
	if (base_blend_pattern > 0.02){
		ALBEDO = mix(cc_base_color.rgb, pattern_lut, base_blend_pattern) * albedo_tex.g;
	}
	else{
		ALBEDO = cc_base_color.rgb * albedo_tex.g;
	}
	
	vec3 result_normal_map = vec3(albedo_norm.a, albedo_norm.r, 1.0);
	NORMALMAP = result_normal_map;
	
//	ALBEDO = vec3(specular_strength);
}
