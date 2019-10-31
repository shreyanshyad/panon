uniform sampler2D tex1;
in mediump vec2 qt_TexCoord0;
out vec4 out_Color;

float height(float distanc,float raw_height){
    return raw_height*exp(-distanc*distanc*8);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{    
    float px_step=0.0000315;
    int max_distance=1280;

    float h=qt_TexCoord0.y;
    bool gr=(h>.5);
    h=abs(2*h-1);
    h+=0.01;

    out_Color=vec4(0,0,0,0);
    float seed=texture(tex1, vec2(qt_TexCoord0.x,0.5)).r;
    for(int j=0;j<256;j++){
        int i=int((2*max_distance+1)*rand(qt_TexCoord0+vec2(j+seed,j)))-max_distance;
        float distanc=abs(i)/1.0/max_distance;
        float x=int(qt_TexCoord0.x/px_step+i)*px_step;

        vec4 raw=texture(tex1, vec2(x,0.5));
        float raw_max=gr?raw.g:raw.r;
        float h_target=height(distanc,raw_max);
        if(h_target-.03<=h && h<=h_target){
            float a=0.4;
            out_Color+=vec4(getRGB(5*x)*a,a);
        }
    }
}