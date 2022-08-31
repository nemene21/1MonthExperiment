uniform float xRatio;
int size = 8;
float multiplier = 0.001;
float intensity = 0.25;
int iterations = size * size;

vec4 effect( vec4 color, Image image, vec2 uvs, vec2 screen_coords )
{
    vec4 blur = Texel(image, uvs);

    for (int x = -size; x < size; x++) {
    for (int y = -size; y < size; y++) {

        blur += Texel(image,uvs + vec2(x * multiplier * xRatio, y * multiplier));

    }
    }

    return blur / iterations * intensity;
}