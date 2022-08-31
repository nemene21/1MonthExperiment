
uniform float intensity;

vec4 effect( vec4 color, Image tex, vec2 uvs, vec2 screen_coords )
{
    vec4 px = Texel(tex, uvs);
    px.r = 1 - px.r; px.g = 1 - px.g; px.b = 1 - px.b;
    return px;
}