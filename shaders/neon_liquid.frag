#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uTime;
uniform vec2 uMouse;

out vec4 fragColor;

// --- MATH UTILS ---
mat2 rot(float a) {
    float s = sin(a), c = cos(a);
    return mat2(c, -s, s, c);
}

float hash(vec3 p) {
    p = fract(p * 0.3183099 + .1);
    p *= 17.0;
    return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

// --- METEOR SDF ---
// Membuat bentuk balok panjang yang tajam (bukan bulat)
float sdBox(vec3 p, vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

void main() {
    vec2 uv = (FlutterFragCoord().xy - 0.5 * uResolution.xy) / uResolution.y;
    vec2 mouse = (uMouse - 0.5 * uResolution.xy) / uResolution.y;

    // Camera Setup
    vec3 ro = vec3(0.0, 0.0, -5.0); // Ray Origin
    vec3 rd = normalize(vec3(uv, 1.0)); // Ray Direction

    // Mouse Interaction: Rotate World
    rd.yz *= rot(mouse.y * 0.5);
    rd.xz *= rot(mouse.x * 0.5 + uTime * 0.1);

    vec3 col = vec3(0.0); // Background Hitam Pekat (True Dark Mode)

    // --- RAYMARCHING LOOP ---
    float t = 0.0;
    for(int i = 0; i < 64; i++) {
        vec3 p = ro + rd * t;

        // Space Folding untuk membuat ribuan meteor tanpa loop berat
        vec3 q = p;
        q.xz *= rot(uTime * 0.2);
        q.xy *= rot(uTime * 0.15);

        // Grid repetition
        vec3 id = floor(q * 0.5);
        q = fract(q * 0.5) - 0.25;

        // Randomize meteor position & speed
        float rnd = hash(id);
        q.z += uTime * (2.0 + rnd * 3.0) + rnd * 10.0;
        q.z = mod(q.z + 2.0, 4.0) - 2.0;

        // Shape: Long Sharp Box (Meteor Body)
        float d = sdBox(q, vec3(0.02, 0.02, 0.8));

        // Color Palette: Cyan & Hot Pink
        vec3 meteorCol = mix(vec3(0.0, 0.9, 1.0), vec3(1.0, 0.0, 0.4), rnd);

        // Glow Calculation (Volumetric Light)
        float glow = exp(-d * 8.0) * 0.05;

        // Add to accumulator
        col += meteorCol * glow;

        t += max(d, 0.05);
        if(t > 20.0 || col.r > 2.0) break; // Early exit for performance
    }

    // --- POST PROCESSING ---
    // Tone mapping agar warna neon tidak "burned out"
    col = col / (col + vec3(1.0));
    col = pow(col, vec3(0.4545)); // Gamma correction

    // Vignette
    vec2 vigUV = FlutterFragCoord().xy / uResolution.xy;
    col *= smoothstep(0.0, 1.5, 1.0 - length(vigUV - 0.5) * 1.2);

    fragColor = vec4(col, 1.0);
}