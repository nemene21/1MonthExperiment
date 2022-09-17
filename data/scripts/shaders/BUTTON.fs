
uniform Image image;
uniform float time;

vec4 effect( vec4 color, Image tex, vec2 uvs, vec2 screen_coords )
{
    vec4 texcolor = Texel(tex, uvs);
    
    return texcolor * color * Texel(image, vec2(uvs.x * 3.92 + time * 0.25, uvs.y + time * 0.5));
}