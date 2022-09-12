
uniform Image noise;

uniform float time;

float snap = 0.0682;
uniform float xSnap;

uniform vec2 screenRes;
uniform Image screen;

vec4 effect( vec4 color, Image tex, vec2 uvs, vec2 screen_coords )
{
    vec4 texcolor = Texel(screen, screen_coords / screenRes);

    uvs.x = int(uvs.x / xSnap) * xSnap;
    uvs.y = int(uvs.y / snap)  * snap;

    float c = int((1 - uvs.y * 2.5) + Texel(noise, vec2(uvs.x, uvs.y + time)).r * 2 > 0.5);

    float grayscale = 1 - floor((texcolor.r + texcolor.g + texcolor.b) * 0.33 + 0.65);

    return vec4(grayscale, grayscale, grayscale, 1.0) * c;
}