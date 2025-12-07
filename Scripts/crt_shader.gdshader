shader_type canvas_item;

// --- GODOT 4 FIX ---
// We must explicitly declare the screen texture. 
// "filter_nearest" ensures your pixel art stays crisp, not blurry.
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

// --- SETTINGS ---
uniform float warp_amount : hint_range(0.0, 1.0) = 0.05;
uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.05; 
uniform float scanline_count : hint_range(0.0, 2000.0) = 300.0;

vec2 warp(vec2 uv) {
	vec2 dc = abs(0.5 - uv);
	dc *= dc;
	
	uv.x -= 0.5;
	uv.x *= 1.0 + (dc.y * (0.3 * warp_amount));
	uv.x += 0.5;

	uv.y -= 0.5;
	uv.y *= 1.0 + (dc.x * (0.4 * warp_amount));
	uv.y += 0.5;
	
	return uv;
}

float vignette(vec2 uv) {
	uv *= 1.0 - uv.xy;
	float value = uv.x * uv.y * 15.0;
	return pow(value, vignette_intensity);
}

void fragment() {
	vec2 uv = warp(SCREEN_UV);
	
	// Black Border Logic
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		// --- GODOT 4 FIX: Use the uniform defined at the top ---
		vec4 text = texture(screen_texture, uv);
		
		// Scanlines
		float slines = sin(uv.y * scanline_count * PI * 2.0);
		slines = 1.0 - (scanline_opacity * (0.5 + 0.5 * slines));
		text.rgb *= slines;
		
		// Vignette
		float vig = vignette(uv);
		text.rgb *= mix(1.0, vig, vignette_opacity);
		
		COLOR = text;
	}
}