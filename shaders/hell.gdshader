shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Vibrant red tint
uniform vec4 tint_color : source_color = vec4(0.92, 0.25, 0.25, 1.0);
uniform float tint_intensity : hint_range(0.0, 1.0) = 0.5;

// Gentle distortion
uniform float distortion_strength = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Subtle wave distortion over time
    float time = TIME * 1.6;
    uv.x += sin(uv.y * 22.0 + time * 2.8) * 0.0045 * distortion_strength;
    uv.x += sin(uv.y * 7.5  + time * 1.1) * 0.0028 * distortion_strength;
    uv.y += cos(uv.x * 16.0 + time * 2.2) * 0.002 * distortion_strength;

    // Sample the screen texture
    vec4 screen_color = texture(SCREEN_TEXTURE, uv);

    // FIX: Instead of multiplying (which darkens), we mix the original color 
    // with our red tint. This ensures the red actually shows up.
    vec3 final_rgb = mix(screen_color.rgb, tint_color.rgb, tint_intensity);

    // Optional: Boost the brightness slightly so it doesn't feel "heavy"
    final_rgb += tint_color.rgb * 0.1;

    COLOR = vec4(final_rgb, screen_color.a);
}