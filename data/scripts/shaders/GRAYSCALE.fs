uniform float intensity;

vec4 effect( vec4 color, Image tex, vec2 uvs, vec2 screen_coords )
{
    vec4 px = Texel(tex, uvs) * color;
    float grayscale = (px.r + px.g + px.b) / 3;

    return px + (vec4(grayscale,grayscale,grayscale,1) - px) * intensity;
}