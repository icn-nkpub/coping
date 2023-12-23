#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec3 iResolution;
uniform float slide;

out vec4 fragColor;

vec2 fragCoord = FlutterFragCoord().xy;

//////////////////////////////

void main() {
	vec3 c;
	float z = iTime;
	float l;
	fragCoord.y = fragCoord.y + slide;

	for (int i = 0; i < 3; i++) {
		vec2 p = fragCoord.xy / iResolution.xy;
		vec2 uv = p;
		p -= .5;
		p.x *= iResolution.x / iResolution.y;
		z += .04;
		l = length(p);
		uv += p / l * (sin(z) + 1.0) * abs(sin(l * 9.0 - z - z));
		c[i] = 0.01 / length(mod(uv, 1.0) - 0.5);
	}

	fragColor = vec4(c / l, iTime);
}
