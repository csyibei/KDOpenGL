#version 300 core
precision lowp float;

out vec4 FragColor;
in vec2 shareTexturePos;

uniform sampler2D texturePic;
uniform sampler2D texturePic1;

void main(void)
{
    FragColor = mix(texture(texturePic, 1.0-shareTexturePos),
                    texture(texturePic1, 1.0-shareTexturePos),
                    0.8);
}
