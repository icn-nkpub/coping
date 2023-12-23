#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec3 iResolution;
uniform float slide;

out vec4 fragColor;

vec2 fragCoord = FlutterFragCoord().xy;

//////////////////////////////

void main() {
	fragCoord.y = fragCoord.y + slide;

	vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;

	float d = length(uv);

	d = sin(d * 8.0 + iTime) / 8.0;
	d = abs(d);

	d = 0.02 / d;

	fragColor = vec4(d, d, d, 1);
}
