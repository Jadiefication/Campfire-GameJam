shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Lighter, softer blue tint (more pale cyan-aquamarine, less deep ocean)
uniform vec3 tint_color = vec3(0.25, 0.62, 0.92);
uniform float intensity = 0.15;           // reduced from 0.3 → much gentler overall color shift

// Much milder distortion
uniform float distortion_strength = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Gentler, more subtle waves — still feels alive but not overwhelming
    float time = TIME * 1.6;

    uv.x += sin(uv.y * 22.0 + time * 2.8) * 0.0045 * distortion_strength;
    uv.x += sin(uv.y * 7.5  + time * 1.1) * 0.0028 * distortion_strength; // softer slow swell

    uv.y += cos(uv.x * 16.0 + time * 2.2) * 0.002 * distortion_strength;

    vec4 screen_color = texture(SCREEN_TEXTURE, uv);

    // Apply the lighter tint
    screen_color.rgb = mix(screen_color.rgb, tint_color, intensity);

    // Very light extra blue boost + desaturation (toned way down so it stays bright)
    float lum = dot(screen_color.rgb, vec3(0.3, 0.6, 0.1));
    screen_color.rgb = mix(screen_color.rgb, vec3(lum) * vec3(0.82, 0.96, 1.15), 0.09);

    COLOR = screen_color;
}