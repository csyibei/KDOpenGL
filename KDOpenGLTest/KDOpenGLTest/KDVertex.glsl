#version 300 core

//layout(location = 0)和glGetAttributeLocation的作用是一样的
layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aInColor;
//attribute vec3 aPos;
//attribute vec3 aInColor;
out vec3 aColor;
void main(void){
    gl_Position = vec4(aPos.x,aPos.y,aPos.z,1.0);
    aColor = aInColor;
}
