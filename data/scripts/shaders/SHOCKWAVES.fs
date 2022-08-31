
uniform float xRatio;

struct Shockwave {

    vec2 position;

    float size;

    float force;
    
    float lifetime;
    float lifetimeMax;

};

uniform int ACTIVE_SHOCKWAVES;

uniform Shockwave shockwaves[16];

vec2 screenDimensions = vec2(800, 600);

vec4 effect( vec4 color, Image image, vec2 uvs, vec2 screen_coords )
{

    for (int i = 0; i < ACTIVE_SHOCKWAVES; i++) {

        Shockwave shockwaveOn = shockwaves[i];

        vec2 normalisedPos = shockwaveOn.position / screenDimensions;

        float multiplier = shockwaveOn.lifetime / shockwaveOn.lifetimeMax;

        vec2 diff = uvs - normalisedPos;

        diff.x /= xRatio;

        float dist = length(diff);

        diff.x /= dist;
        diff.y /= dist;

        float size = (1 - multiplier) * shockwaveOn.size;

        vec2 disp = diff * int(dist < size && dist > size * 0.25) * shockwaveOn.force;

        uvs -= disp * multiplier;

    }

    return Texel(image, uvs) * color;
}