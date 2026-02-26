#pragma header

uniform float threshold; // Default is 0.05
uniform float intensity; // Default is 1.0
// uniform float radius;
uniform float colorRange;

vec4 blend(in vec2 Coord, in sampler2D Tex, in float MipBias)
{
	vec2 TexelSize = MipBias / openfl_TextureSize.xy;

	vec4 Color = texture2D(Tex, Coord);
	
	for (float i = 1.0; i <= 6.0; i += 1.0)
	{
		float inv = 1.0 / i;
		Color += texture2D(Tex, Coord + vec2(TexelSize.x, TexelSize.y) * inv);
		Color += texture2D(Tex, Coord + vec2(-TexelSize.x, TexelSize.y) * inv);
		Color += texture2D(Tex, Coord + vec2(TexelSize.x, -TexelSize.y) * inv);
		Color += texture2D(Tex, Coord + vec2(-TexelSize.x, -TexelSize.y) * inv);
	}
	
	return Color / colorRange;
}

void main()
{
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize.xy;
	vec2 uv = (fragCoord.xy / openfl_TextureSize.xy) * vec2(1.0, 1.0);
	vec4 Color = texture2D(bitmap, uv);
	vec4 Highlight = clamp(blend(uv, bitmap, 4.0) - threshold, 0.0, 1.0) * 1.0 / (1.0 - threshold);
	
	gl_FragColor = 1.0 - (1.0 - Color) * (1.0 - Highlight * intensity);
}
