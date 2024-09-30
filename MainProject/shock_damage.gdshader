shader_type canvas_item;

/**
Color to use for the shock.
*/
uniform vec3 shock_color : source_color = vec3(1.0, 0.0, 0.0);
/**
Initial amplitude of the shock. This will start at this amplitude and
gradually attenuate.
*/
uniform float amplitude = 30.0;
/**
How fast shold it move side to side, more frequency means it'll move more quickly
side to side.
*/
uniform float frequecy = 10.0;

uniform float duration = 3.0;
uniform float onoff = 0.0;

void vertex() {
	float exponent = mod(TIME, duration);
	VERTEX.x += amplitude * exp(-duration*exponent) * sin(frequecy*exponent) * onoff;
}

void fragment() {
	float exponent = mod(TIME, duration) * onoff;
	vec3 normal_color = texture(TEXTURE, UV).rgb;
	COLOR.rgb = normal_color + (shock_color * exp(-duration*exponent) * onoff);
}
