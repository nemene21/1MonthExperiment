uniform float intensity;

float snap = 0.0625;

float partRot = 3.14 * 0.2;

extern int hp;

vec4 effect( vec4 color, Image tex, vec2 uvs, vec2 screen_coords )
{

    vec2 snappedUvs = vec2(int(uvs.x / snap) * snap, int(uvs.y / snap) * snap);

    float rotation = atan(snappedUvs.y - 0.5, snappedUvs.x - 0.5) + 3.14;

    vec4 px = Texel(tex, uvs) * color;
    px.a -= 0.8 * int(rotation > partRot * hp * 2 + 0.1);

    float grayscale = (px.r + px.g + px.b) / 3;

    return px + (vec4(grayscale,grayscale,grayscale,px.a) - px) * intensity;

}