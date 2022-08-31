uniform float diff;

uniform Image mask;

vec4 effect( vec4 color, Image image, vec2 uvs, vec2 screen_coords )
{
    vec4 px = Texel(image,uvs);
    float doShade = Texel(mask,uvs).r; float doNot = Texel(mask,uvs).r *-1 +1;
    px.r = Texel(image,vec2(uvs.x + diff,uvs.y)).r * doShade + px.r * doNot;
    px.b = Texel(image,vec2(uvs.x - diff,uvs.y)).b * doShade + px.b * doNot;
    return px;
}