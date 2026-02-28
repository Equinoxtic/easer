// Bokeh disc.
// by David Hoskins.
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

#pragma header

uniform float radius;
uniform float amount;

#define PI 3.141596

// This is (3.-sqrt(5.0))*PI radians, which doesn't precompiled for some reason.
// The compiler is a dunce I tells-ya!!
#define GOLDEN_ANGLE 2.39996323

#define NUMBER 15

#define ITERATIONS (GOLDEN_ANGLE * NUMBER)

//-------------------------------------------------------------------------------------------
// This creates the 2D offset for the next point.
// (r-1.0) is the equivalent to sqrt(0, 1, 2, 3...)
vec2 Sample(in float theta, inout float r)
{
	r += 1.0 / r;
	return (r - 1.0) * vec2(cos(theta), sin(theta));
}

//-------------------------------------------------------------------------------------------
vec3 bokeh(sampler2D tex, vec2 uv, float radius, float amount)
{
	vec3 acc = vec3(0.0);
	vec3 div = vec3(0.0);
	vec2 pixel = vec2(openfl_TextureSize.y / openfl_TextureSize.x, 1.0) * radius * 0.006;
	float r = 1.0;
	for (float j = 0.0; j < ITERATIONS; j += GOLDEN_ANGLE)
	{
		vec3 col = texture2D(tex, uv + pixel * Sample(j, r), radius * 1.5).xyz;
		vec3 bokeh = vec3(5.0) + pow(col, vec3(9.0)) * amount;
		acc += col * bokeh;
		div += bokeh;
	}
	return acc / div;
}


void main()
{
	
	vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize.xy;
	vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
	float a = amount;
	
	vec2 xy = vec2(uv.x, uv.y);
	float dis = distance(fragCoord.xy, openfl_TextureSize.xy / 2.0);
	
	gl_FragColor = vec4(bokeh(bitmap, xy, radius * dis * 0.001, a), 1.0);
}
