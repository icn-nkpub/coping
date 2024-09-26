#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec3 iResolution; // x, y, z: resolution in pixels
uniform float slide;
uniform float layer;

out vec4 fragColor;

vec2 fragCoord = FlutterFragCoord().xy;

void main() {
    // Adjust fragCoord.y based on slide (animation)
    fragCoord.y += slide;

    // Normalize fragCoord (divide by iResolution.xy to get 0-1 range)
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Adjust aspect ratio (preserve shape distortion due to screen aspect ratio)
    vec2 p = uv - 0.5;
    p.x *= iResolution.x / iResolution.y;  // Correct aspect ratio
	
    // Set the rotation angle based on the `layer` uniform value.
    // If layer == 1, angle = 0 radians; if layer == 2, angle = 45 degrees (π/4 radians).
    float rotationAngle = (layer == 1.0) ? 0.0 : 0.785398; // 45 degrees in radians
    
    // Create the rotation matrix using the calculated rotation angle.
    mat2 rotationMatrix = mat2(cos(rotationAngle), -sin(rotationAngle),
                               sin(rotationAngle),  cos(rotationAngle));
    
    // Apply the rotation to the coordinates.
    p = rotationMatrix * p;  // Rotate the coordinates
    
    vec3 color = vec3(0.0);
    float intensity, zoom = iTime;
    
    float distance = length(p);
    
    // Use polar coordinates to create a starburst pattern
    float angle = atan(p.y, p.x);  // Calculate the angle of the current point

    // Modulate the UV based on the angle and distance to create multiple directions
    uv += p / distance * (sin(0 * angle + zoom) + 1.0) * abs(sin(distance * 9.0 - zoom - zoom));
        
    for (int i = 0; i < 3; i++) {
        // Calculate color for each channel
        color[i] = 0.01 / length(mod(uv, 1.0) - 0.5);
    }

	// Clamp the final color to a maximum of 50% white (grey)	
	color = color / length(p*4);
	color = min(color, vec3(5));

    // Output the final fragment color, using iTime as alpha
    fragColor = vec4(color, color.x);
}
