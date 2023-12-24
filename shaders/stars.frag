#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec3 iResolution;
uniform float slide;

out vec4 fragColor;

vec2 fragCoord = FlutterFragCoord().xy;
float PI = 3.14159265359;

//////////////////////////////

vec2 rotate(vec2 v, float angle) {
    float cosAngle = cos(angle);
    float sinAngle = sin(angle);
    return vec2(
        v.x * cosAngle - v.y * sinAngle,
        v.x * sinAngle + v.y * cosAngle
    );
}

void main() {
	fragCoord.y = fragCoord.y + slide;

	vec2 uv = (fragCoord * 2 - iResolution.xy) / iResolution.y;
	float l = length(uv);

	float s = sqrt(sqrt(l)) + (iTime / 10);
	float count = 20 * 2;
	float d = s;
	d = sin(d * PI * count);

	float count2 = ((floor((s * count)) / count) - 0.1) * count;
	float t = PI/(count/count2) + atan(uv.y, uv.x);
	t = t + (((count) / count2 * 20) * iTime / 40);
	t = (t + PI) / (2 * PI);
	t = sin(t * PI * (14 - (count2 * 2)));

	float c = smoothstep(1.3, 2, d + t);
	if (s < 1) {
		fragColor = vec4(c, c, c, c-.2);
	} else {
		fragColor = vec4(0, 0, 0, 0);
	}
}
