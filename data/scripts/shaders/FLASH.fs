uniform float intensity;

vec4 effect( vec4 color, Image image, vec2 uvs, vec2 screen_coords )
{
    vec4 px = Texel(image,uvs);
    px.r = px.r + (color.r - px.r) * intensity;
    px.g = px.g + (color.g - px.g) * intensity;
    px.b = px.b + (color.b - px.b) * intensity;
    px.a *= color.a;
    
    return px * color;
}