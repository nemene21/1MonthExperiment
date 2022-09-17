
uniform Image lightImage;

uniform Image vignetteMask;

extern float xRatio;

struct Shockwave {

    vec2 position;

    float size;

    float force;
    
    float lifetime;
    float lifetimeMax;

};

extern int ACTIVE_SHOCKWAVES;

extern Shockwave shockwaves[16];

vec2 screenDimensions = vec2(768, 576);

extern Image hurtVignette;

uniform float hurtVignetteIntensity = 0.0;

float directions = 6.0;
float quality = 2.0;
float radius = 0.006;

float PI2 = 6.2831;

float iterations = directions * quality;

uniform float intensityBloom = 1;

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

    vec4 glow;

    float angle = PI2 / directions;
    float qualityDiv = 1.0 / quality;

    for (float directionOn = 0.0; directionOn < PI2; directionOn += angle) {

        for (float i = qualityDiv; i < quality; i += qualityDiv) {

            vec4 lookup = Texel(image, uvs + vec2(cos(directionOn) * xRatio, sin(directionOn)) * radius * i);

            glow += lookup * lookup * lookup * lookup * (i / quality) / i;

        }

    }

    vec4 px = Texel(image, uvs);

    glow /= iterations;
    px += glow * intensityBloom;

    px = px * Texel(lightImage, uvs) * Texel(vignetteMask, uvs); // Get pixel

    return px * color + vec4(0.5, 0, 0, 1) * hurtVignetteIntensity * Texel(hurtVignette, uvs).r;

}