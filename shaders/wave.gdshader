shader_type canvas_item;

// Liquid
uniform float liquid_level : hint_range(0.0, 1.0) = 0.5;
uniform vec4 liquid_color : source_color = vec4(0.2, 0.5, 1.0, 0.8);
uniform vec4 foam_color : source_color = vec4(0.8, 0.9, 1.0, 0.6);

// Waves
uniform float wave_amplitude : hint_range(0.0, 0.3) = 5; // increased for bigger waves
uniform float wave_frequency : hint_range(0.0, 50.0) = 5.0;
uniform float wave_speed : hint_range(0.0, 5.0) = 2.0;

// Gravity
uniform float gravity_angle : hint_range(-3.14159, 3.14159) = 0.0;

// Visual
uniform float foam_thickness : hint_range(0.0, 0.1) = 0.02;
uniform float shine_intensity : hint_range(0.0, 1.0) = 0.3;
uniform bool add_bubble = true;
uniform float bubble_scale : hint_range(1.0, 100.0) = 10.0;
uniform float bubble_speed : hint_range(0.0, 2.0) = 0.5;

// Pixelation
uniform float pixel_size : hint_range(4.0, 512.0) = 32.0; // lower = bigger pixels

// Noise
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x)
         + (c - a) * u.y * (1.0 - u.x)
         + (d - b) * u.x * u.y;
}

vec2 rotate(vec2 v, float a) {
    float c = cos(a);
    float s = sin(a);
    return vec2(v.x * c - v.y * s,
                v.x * s + v.y * c);
}

void fragment() {

    // Pixelated UV
    vec2 uv = floor(UV * pixel_size) / pixel_size;

    vec2 centered = uv - 0.5;
    vec2 rotated = rotate(centered, -gravity_angle) + 0.5;

    // Adaptive wave frequency based on stretch
    float stretch = length(vec2(dFdx(UV.x), dFdy(UV.y))) * 500.0;
    float adaptive_freq = wave_frequency * stretch;

    float wave = sin(rotated.x * adaptive_freq + TIME * wave_speed) * wave_amplitude;
    float surface_y = (1.0 - liquid_level) + wave;

    if (rotated.y > surface_y) {

        vec4 base = liquid_color;

        // Pixelated internal noise
        vec2 internal_uv = floor(vec2(rotated.x * 3.0,
                                      rotated.y * 3.0 + TIME * 0.5) * (pixel_size*0.5))
                                      / (pixel_size*0.5);

        float internal_wave = noise(internal_uv) * 0.2;
        base.rgb += vec3(internal_wave);

        if (add_bubble) {
            vec2 bubble_uv = floor(rotated * bubble_scale * pixel_size) / pixel_size;
            bubble_uv.y += TIME * bubble_speed;
            float bubble = step(0.96, noise(bubble_uv));
            base.rgb += vec3(bubble * 0.3);
        }

        float shine = pow(1.0 - abs(uv.x - 0.5) * 2.0, 3.0) * shine_intensity;
        base.rgb += vec3(shine);

        float depth = 1.0 - (rotated.y - surface_y) / (1.0 - surface_y);
        base.rgb *= 0.7 + depth * 0.3;

        COLOR = base;

    } else if (rotated.y > surface_y - foam_thickness) {

        vec2 foam_uv = floor(vec2(rotated.x * 20.0,
                                  TIME * 2.0) * pixel_size) / pixel_size;

        float foam_factor = (surface_y - rotated.y) / foam_thickness;
        foam_factor *= noise(foam_uv);

        COLOR = mix(liquid_color, foam_color, foam_factor);

    } else {

        COLOR = vec4(0.0);
    }
}