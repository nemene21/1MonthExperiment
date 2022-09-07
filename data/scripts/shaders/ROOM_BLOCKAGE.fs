
uniform Image noise;

uniform float time;

float snap = 0.039;
uniform float xSnap;

vec4 effect( vec4 color, Image tex, vec2 uvs, vec2 screen_coords )
{
    vec4 texcolor = vec4(0, 0, 0, 1);

    uvs.x = int(uvs.x / xSnap) * xSnap;
    uvs.y = int(uvs.y / snap)  * snap;

    float c = int((1 - uvs.y * 2.5) + Texel(noise, vec2(uvs.x, uvs.y + time)).r * 2 > 0.5);

    return texcolor * c * (1 - uvs.y * 0.5);
}