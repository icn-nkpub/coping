#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec3 iResolution; // x, y, z: resolution in pixels
uniform float slide;
uniform float layer;
uniform float aniseed;

out vec4 fragColor;

vec2 fragCoord = FlutterFragCoord().xy;

void main() {
    vec3 iResolution = iResolution;

    // Adjust fragCoord.y based on slide (animation)
    fragCoord.y += slide;

    // Normalize fragCoord (divide by iResolution.xy to get 0-1 range)
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Adjust aspect ratio (preserve shape distortion due to screen aspect ratio)
    vec2 p = uv - 0.5;
    p.x *= iResolution.x / iResolution.y;  // Correct aspect ratio

    // --- Fisheye distortion ---
    float r = length(p); // Get distance from the center (0.5, 0.5)
    if (r > 0.0) {
        float theta = atan(p.y, p.x);  // Polar angle
        r = pow(r, 0.75 + iTime); // Adjust this power to control the strength of the fisheye distortion (values less than 1 cause outward distortion)
        p = r * vec2(cos(theta), sin(theta));  // Convert back to cartesian coordinates
    }
    
    // --- Apply rotation only after fisheye distortion ---
    float rotationAngle = 0.0;
    if (layer == 1) {
        rotationAngle = 3.14159265 / 2.0;  
    } else if (layer == 2) {
        rotationAngle = 3.14159265 / 3;  
    }

    // Create the rotation matrix using the calculated rotation angle
    mat2 rotationMatrix = mat2(cos(rotationAngle), -sin(rotationAngle),
                               sin(rotationAngle),  cos(rotationAngle));

    // Apply the rotation to the already fisheye-distorted coordinates
    p = rotationMatrix * p;

    // --- Modulate UV based on distance from center and angle ---
    vec3 color = vec3(0.0);
    float zoom = aniseed + (layer / 4.0) + iTime;
    float distance = length(p);  // Recalculate distance after fisheye effect

    // Apply zoom increment
    zoom += 0.07;

    // Use polar coordinates to create a starburst pattern
    float angle = atan(p.y, p.x);  // Calculate the angle of the current point

    // Modulate the UV based on the angle and distance to create multiple directions
    uv += p / distance * (sin(0.0 * angle + zoom) + 1.0) * abs(sin(distance * 9.0 - zoom - zoom));
    
    // Calculate color based on UV modulation
    for (int i = 0; i < 3; i++) {
        color[i] = 0.1 / length(mod(uv, 1.0) - 0.5);
    }

    // Fading factor based on distance: closer to the center, brighter; farther away, dimmer
    float fade = exp(-distance * 3.0);  // Exponential falloff, you can adjust the `3.0` for different rates of fading

    // Apply the fade to the color
    color *= fade;

    // Smooth falloff using smoothstep
    float maxDistance = 0.0; // Adjust this to control the range over which the color fades
    float smoothFalloff = smoothstep(.1, maxDistance, distance * (1.0 - ((iTime) * .3)));

    // Modify the color intensity with a smoother function
    color *= smoothFalloff * distance * 20.0;

    // Output the final fragment color, using color.x as the alpha for some transparency effect
    fragColor = vec4(color, color.x);
}
