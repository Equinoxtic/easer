#pragma header

uniform float offset;
uniform float intensity;
uniform float area;

vec2 computeUV(vec2 uv, float k, float kcube){
	
	vec2 t = uv - 0.5;
	float r2 = t.x * t.x + t.y * t.y;
	float f = 0.0;
	
	if (kcube == 0.0) {
		f = 1.0 + r2 * k;
	} else {
		f = 1.0 + r2 * ( k + kcube * sqrt( r2 ) );
	}
	
	// prevent the result of a flipped image when using in FNF (thanks to @srtpro278 on CNE discord <3)
	return (f * t + 0.5);
}

void main() {
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize.xy;
	vec2 uv = fragCoord/openfl_TextureSize.xy;
	//vec2 uv = getCamPos(openfl_TextureCoordv);
	
	vec4 col;
	
	col.r = texture2D(bitmap, computeUV(uv, intensity + offset, area)).r; 
	col.g = texture2D(bitmap, computeUV(uv, intensity, area)).g; 
	col.b = texture2D(bitmap, computeUV(uv, intensity - offset, area)).b; 
	col.a = texture2D(bitmap, computeUV(uv, intensity, area)).a;
	
	gl_FragColor = col;
}
