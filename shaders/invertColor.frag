#pragma header

uniform float intensity;

void main() {
	
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize.xy;
	vec2 uv = openfl_TextureCoordv;

	vec4 col;
	col.r = intensity - textureCam(bitmap, uv).r;
	col.g = intensity - textureCam(bitmap, uv).g;
	col.b = intensity - textureCam(bitmap, uv).b;
	col.a = 1.0;

	// Output to screen
	gl_FragColor = col;
}
