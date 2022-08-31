uniform float snapX;
uniform float snapY;

vec4 effect( vec4 color, Image image, vec2 uvs, vec2 screen_coords )
{
    vec4 px = Texel(image, vec2(floor(uvs.x / snapX) * snapX, floor(uvs.y / snapY) * snapY));

    return px * color;
}