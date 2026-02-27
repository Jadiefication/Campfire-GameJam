shader_type canvas_item;

// This captures the game world behind the ColorRect
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 water_tint : source_color = vec4(0.1, 0.4, 0.7, 0.7);
uniform float transition_fill : hint_range(0.0, 2.5) = 0.0; // Start at 0.0
uniform float pixel_size : hint_range(1.0, 10.0) = 4.0;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

vec4 draw_bubble(vec2 local_uv, vec2 id, float scale) {
    float h = hash(id);
    vec2 jitter = (vec2(hash(id + 0.5), hash(id + 0.8)) - 0.5) * (scale * 0.8);
    vec2 center = vec2(scale * 0.5) + jitter;
    float radius = (scale * 0.3) + h * (scale * 0.35);
    float d = distance(local_uv, center);
    if (d > radius) return vec4(0.0);
    if (distance(local_uv, center - radius * 0.4) < radius * 0.35) return vec4(1.0);
    if (d > radius - 1.5) return vec4(0.9, 0.9, 1.0, 0.9);
    return vec4(0.4, 0.7, 1.0, 0.6);
}

void fragment() {
    // 1. Grab the screen and add a slight wave distortion
    vec2 uv = SCREEN_UV;
    float distortion = sin(TIME * 2.0 + uv.y * 10.0) * 0.005 * smoothstep(0.0, 1.0, transition_fill);
    uv.x += distortion;
    vec4 screen_color = texture(SCREEN_TEXTURE, uv);

    // 2. Generate Bubbles
    vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 p_uv = floor(UV * res / pixel_size);
    vec4 bubble_layer = vec4(0.0);

    for (int l = 0; l < 3; l++) {
        float layer_f = float(l);
        float scale = 12.0 + layer_f * 6.0;
        float scroll = TIME * 25.0 * (1.0 + layer_f * 0.2);
        // Vertical offset controlled by transition_fill
        float v_offset = (transition_fill * (res.y / pixel_size) * 1.5);
        vec2 st = vec2(p_uv.x, p_uv.y + scroll - v_offset + (layer_f * 50.0));

        for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
                vec2 id = floor(st / scale) + vec2(float(x), float(y));
                vec4 b = draw_bubble(st - (id * scale), id, scale);
                if (b.a > 0.0) bubble_layer = mix(bubble_layer, b, b.a);
            }
        }
    }

    // 3. Smooth Transition Edge (Wipe from bottom to top)
    float edge = smoothstep(UV.y - 0.1, UV.y + 0.1, transition_fill);

    // Mix screen with tint, then add bubbles
    vec4 tinted_screen = mix(screen_color, water_tint, water_tint.a);
    vec4 final_bubble_view = mix(tinted_screen, bubble_layer, bubble_layer.a);

    COLOR = mix(screen_color, final_bubble_view, edge);
}