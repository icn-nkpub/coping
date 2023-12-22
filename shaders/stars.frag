#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec3 iResolution;

out vec4 fragColor;

vec2 fragCoord = FlutterFragCoord().xy;

//////////////////////////////

void main(){
	vec3 c;
	float l,z=iTime;
	for(int i=0;i<3;i++) {
		vec2 uv,p=fragCoord.xy/iResolution.xy;
		uv=p;
		p-=.5;
		p.x*=iResolution.x/iResolution.y;
		z+=.07;
		l=length(p);
		uv+=p/l*(sin(z)+1.)*abs(sin(l*9.-z-z));
		c[i]=.01/length(mod(uv,1.)-.5);
	}
	fragColor=vec4(c/l,iTime);
}
