shader_type canvas_item;

// This hint is vital for Godot 4.x to get the right colors
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float red_intensity : hint_range(0.0, 1.0) = 0.6;
uniform float distortion_strength = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Distortion math
    float time = TIME * 1.6;
    uv.x += sin(uv.y * 22.0 + time * 2.8) * 0.0045 * distortion_strength;
    uv.y += cos(uv.x * 16.0 + time * 2.2) * 0.002 * distortion_strength;

    // Sample the background
    vec4 screen_color = texture(SCREEN_TEXTURE, uv);
    
    // Create a pure red tint
    vec3 red_tint = vec3(0.9, 0.1, 0.1); 

    // BLENDING: Screen Mode (Result = 1 - (1-A)*(1-B))
    // This makes things lighter and forces the red to show up even on dark colors.
    vec3 screen_blend = 1.0 - (1.0 - screen_color.rgb) * (1.0 - red_tint);
    
    // Mix the original with the "Red Screened" version
    vec3 final_color = mix(screen_color.rgb, screen_blend, red_intensity);

    // Final check: If it's STILL blue, we manually kill the blue channel
    final_color.b *= 0.5; 
    
    COLOR = vec4(final_color, screen_color.a);
}