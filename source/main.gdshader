shader_type canvas_item; 

uniform float border_size = 10.0;
uniform vec4 color_a: hint_color;
uniform vec4 color_b: hint_color;


bool in_rect(vec2 p, vec2 tl, vec2 br)
{
	return p.x >= tl.x && p.x <= br.x && p.y >= tl.y && p.y <= br.y;
}


bool is_border(vec2 p, vec2 s, sampler2D t)
{
	vec2 bsv = vec2(border_size * 2.0, border_size * 2.0);
	
	if (!in_rect(p, bsv, s - bsv))
	{
		return true;
	}
	
	for (float y = -1.0; y <= 1.0; y += 1.0)
	{
		for (float x = -1.0; x <= 1.0; x += 1.0)
		{
			if ( x == y && x == 0.0)
			{
				continue;
			}
			
			vec2 cp = p + vec2(x, y) * border_size; 
			vec2 cpuv = cp / s;
			vec4 cc = texture(t, cpuv);
			
			if (cc.a != 0.0)
			{
				return true;
			}
		}
	}
	
	return false;
}
		


vec4 blended_color(float val)
{ 
	vec4 delta = color_b - color_a;
	return color_a + delta * clamp(val, 0.0, 1.0);
}


float fmod(float a, float b)
{
	return (a - b * floor(a / b));
}


vec2 texture_size(sampler2D tex)
{
	ivec2 size = textureSize(tex, 0);
	return vec2(
		float(size.x),
		float(size.y)
	);
}


float wave(vec2 position, vec2 direction, float speed, float frequency)
{
	vec2 offset_position = position + direction * TIME * speed;
	return offset_position.y / frequency + sin(offset_position.x / frequency);
}


vec4 color(vec2 position)
{
	float val = 0.0; 
	
	val += wave(position, vec2(-1.0, 1.0), 50.0, 100.0);
	val += wave(position, vec2(-1.0, 0.0), 25.0, 50.0);
	val += wave(position, vec2(0.5, -1.0), 10.0, 250.0);
	val += wave(position, vec2(1.0, 0.0), 50.0, 150.0);
	val += wave(position, vec2(1.0, 0.0), 50.0, 150.0);
	val += wave(position, vec2(1.0, 0.0), 50.0, 150.0);
	
	float m = 10.0;
	val = fmod(val, m) / m;
	
	return blended_color(val); 
}


void fragment() 
{
	vec4 c = texture(TEXTURE, UV);
	vec2 s = vec2(1920.0, 1080.0);
	vec2 p = UV * s;
	
	if (c.a == 0.0 && is_border(p, s, TEXTURE))
	{
		c = color(p);
	}
	
	COLOR = c;
}