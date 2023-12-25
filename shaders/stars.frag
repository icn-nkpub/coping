#include <flutter/runtime_effect.glsl>

uniform float time;
uniform vec3 size;
uniform float slide;
uniform float cycle;
uniform float iniCount;

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

	vec2 uv = (fragCoord * 2 - size.xy) / size.y;
	uv = rotate(uv, cycle * PI);
	uv = (uv * (2.5-cycle))/3;
	float l = length(uv);

	float s = sqrt(sqrt(l)) + (time / 20);
	float count = iniCount * 2;
	float d = s;
	d = sin(d * PI * count);

	float count2 = ((floor((s * count)) / count) - 0.1) * count;
	float t = PI/(count/count2) + atan(uv.y, uv.x);
	t = t + (sqrt(pow(count2, 4) / 	3) * time / 22);
	t = (t + PI) / (2 * PI);
	t = sin(t * PI * (14 - (count2 * 2)));

	float c = step(1.9, d + t);
	if (s < 1 && s > 0.72) {
		fragColor = vec4(c, c, c, c);
	} else {
		fragColor = vec4(0, 0, 0, 0);
	}
}
