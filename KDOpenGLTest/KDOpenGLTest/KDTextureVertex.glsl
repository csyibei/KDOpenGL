#version 300 core

layout(location = 0) in vec3 aPos;
layout(location = 1) in vec2 aTexturePos;

uniform mat4 matrix;

out vec2 shareTexturePos;

void main(void)
{
    gl_Position = matrix * vec4(aPos.x,aPos.y,aPos.z,1.0);
    shareTexturePos = vec2(aTexturePos.x, aTexturePos.y);
}
