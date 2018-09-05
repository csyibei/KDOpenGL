#version 300 core
precision lowp float;

out vec4 FragColor;
in vec2 shareTexturePos;

uniform sampler2D texturePic;

void main(void)
{
    FragColor = texture(texturePic,shareTexturePos);
}
