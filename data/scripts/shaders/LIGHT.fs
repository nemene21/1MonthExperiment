
uniform Image lightImage;

vec4 effect( vec4 color, Image image, vec2 uvs, vec2 screen_coords )
{
    vec4 px = Texel(image,uvs) * Texel(lightImage,uvs);

    return px;
}