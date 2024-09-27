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

    // Set the rotation angle based on the `layer` uniform value.
    // If layer == 1, angle = 0 radians; if layer == 2, angle = 45 degrees (π/4 radians).
    float rotationAngle = 0;//(layer == 1.0) ? 1 - iTime : iTime; // 45 degrees in radians
    // rotationAngle *= 5 * 0.01745329;
    
    // Create the rotation matrix using the calculated rotation angle.
    mat2 rotationMatrix = mat2(cos(rotationAngle), -sin(rotationAngle),
                               sin(rotationAngle),  cos(rotationAngle));
    
    // Apply the rotation to the coordinates.
    p = rotationMatrix * p;  // Rotate the coordinates
    
    vec3 color = vec3(0.0);
    float zoom = aniseed + (layer/4) + iTime;
    
    float distance = length(p);  // Calculate distance from center

    // Apply zoom increment
    zoom += 0.07;

    // Use polar coordinates to create a starburst pattern
    float angle = atan(p.y, p.x);  // Calculate the angle of the current point

    // Modulate the UV based on the angle and distance to create multiple directions
    uv += p / distance * (sin(0 * angle + zoom) + 1.0) * abs(sin(distance * 9.0 - zoom - zoom));
    
    // Calculate color based on UV modulation
    for (int i = 0; i < 3; i++) {
        color[i] = 0.1 / length(mod(uv, 1.0) - 0.5);
    }

    // Fading factor based on distance: closer to the center, brighter; farther away, dimmer
    float fade = exp(-distance * 3.0); // Exponential falloff, you can adjust the `3.0` for different rates of fading

    // Apply the fade to the color
    color *= fade;

    // // Clamp the final color to a maximum of distance
    // color = min(color, 5-(distance*10));

    // Smooth falloff using smoothstep
    float maxDistance = 0.0; // Adjust this to control the range over which the color fades
    float smoothFalloff = smoothstep(.1, maxDistance, distance*(5-((0.5+iTime)*3.05)));

    // Modify the color intensity with a smoother function
    color *= smoothFalloff * distance * 20;

    // Output the final fragment color, using color.x as the alpha for some transparency effect
    fragColor = vec4(color, color.x);
}
