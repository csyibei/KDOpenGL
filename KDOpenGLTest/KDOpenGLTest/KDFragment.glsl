#version 300 core
precision mediump float;
//varying vec3 aColor
out vec4 FragColor;
in vec3 aColor;
uniform vec4 changeColor;
void main(void){
//    FragColor = vec4(aColor.r,aColor.g,aColor.b,1.0);
    FragColor = changeColor;
}
