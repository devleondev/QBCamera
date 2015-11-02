
varying highp vec2 textureCoordinate;
uniform sampler2D inputImageTexture;

void main()
{
    lowp vec4 pixcol = texture2D(inputImageTexture, textureCoordinate);
    
    //绿色通道
    lowp vec4 greenLayer = vec4(vec3(pixcol.g), pixcol.a);
    
    //蓝色通道
    lowp vec4 blueLayer = vec4(vec3(pixcol.b), pixcol.a);
    
    //绿色 + 蓝色 叠加混合
    mediump float ra = 0.0;
    if (2.0 * greenLayer.r < greenLayer.a)
    {
        ra = 2.0 * blueLayer.r * greenLayer.r + blueLayer.r * (1.0 - greenLayer.a) + greenLayer.r * (1.0 - blueLayer.a);
    }
    else
    {
        ra = blueLayer.a * greenLayer.a - 2.0 * (greenLayer.a - greenLayer.r) * (blueLayer.a - blueLayer.r) + blueLayer.r * (1.0 - greenLayer.a) + greenLayer.r * (1.0 - blueLayer.a);
    }
    
    mediump float ga = 0.0;
    if (2.0 * greenLayer.g < greenLayer.a)
    {
        ga = 2.0 * blueLayer.g * greenLayer.g + blueLayer.g * (1.0 - greenLayer.a) + greenLayer.g * (1.0 - blueLayer.a);
    }
    else
    {
        ga = blueLayer.a * greenLayer.a - 2.0 * (greenLayer.a - greenLayer.g) * (blueLayer.a - blueLayer.g) + blueLayer.g * (1.0 - greenLayer.a) + greenLayer.g * (1.0 - blueLayer.a);
    }
    
    mediump float ba = 0.0;
    if (2.0 * greenLayer.b < greenLayer.a)
    {
        ba = 2.0 * blueLayer.b * greenLayer.b + blueLayer.b * (1.0 - greenLayer.a) + greenLayer.b * (1.0 - blueLayer.a);
    }
    else
    {
        ba = blueLayer.a * greenLayer.a - 2.0 * (greenLayer.a - greenLayer.b) * (blueLayer.a - blueLayer.b) + blueLayer.b * (1.0 - greenLayer.a) + greenLayer.b * (1.0 - blueLayer.a);
    }
    
    gl_FragColor = vec4(ra, ga, ba, 1.0);
}