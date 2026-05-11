// Glory Kill stagger tint — based on Doom 4 Doom-style shader; dot mask replaced with vertical scanlines.

uniform float timer;
vec4 Process(vec4 color)
{
	vec2 texCoord = gl_TexCoord[0].st;
	vec4 orgColor = getTexel(texCoord) * color;
	float cp = (sin(-pixelpos.y/8.0-timer*8.0)+1.0)/2.0;
	cp = clamp(cp-0.35, 0.0, 1.0);
	vec3 glowColor = vec3(0.0);
	if( orgColor.r > 0.51 ) glowColor = vec3(2.0, 0.75, 0.15);
	else glowColor = vec3(2.0, 0.22, 0.22);
	return vec4(mix(orgColor.rgb, glowColor, cp), orgColor.a);
}
