
float directions = 8.0;
float quality = 3.0;
float radius = 0.005;

float PI2 = 6.2831;

float iterations = directions * quality * 2;

vec4 effect( vec4 color, Image image, vec2 uvs, vec2 screen_coords )
{
    vec4 blur = Texel(image, uvs);

    float angle = PI2 / directions;
    float qualityDiv = 1.0 / quality;

    for (float directionOn = 0.0; directionOn < PI2; directionOn += angle) {

        for (float i = qualityDiv; i < quality; i += qualityDiv) {

            blur += Texel(image, uvs + vec2(cos(directionOn), sin(directionOn)) * radius * i);

        }

    }

    vec4 px = blur / iterations;
    px.rgb *= 0;

    return px * 0.5;
}