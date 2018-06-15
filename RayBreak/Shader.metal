//
//  Shader.metal
//  RayBreak
//
//  Created by 4Axis_Admin on 5/31/18.
//  Copyright © 2018 caroline. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct VertexIn {
    float3 position[[attribute(0)]];
    float4 color [[attribute(1)]] ;
};


struct VertexOut {
    float4 position [[ position]];
    float4 color ;
};


struct VertexInTexture {
    float3 position[[attribute(0)]];
    float4 color [[attribute(1)]] ;
    float2 textureCoordinates [[attribute(2)]];
};

struct VertexOutTexture {
    float4 position [[ position]];
    float4 color ;
    float2 textureCoordinates;
};

struct ModelConstant{
    
    float4x4 modelMatrix;
    
};


struct Constants{
    float animateBy;
};

vertex VertexOut vertex_shader(VertexIn vertices [[stage_in]]){
    
    VertexOut v;
    v.position =  float4(vertices.position ,1 );
    //   v.position.xy += cos(constants.animateBy);
    v.color = vertices.color;
    
    return v;
    
}

fragment half4 fragment_shader(VertexOut vIn [[stage_in]]){
    //   return half4(1,1,0.75,0.0);
    return half4(vIn.color);
}



vertex VertexOutTexture vertex_shader_texture(VertexInTexture vertices [[stage_in]]){
    
    VertexOutTexture v;
    v.position =  float4(vertices.position ,1 );
    //v.position.xy += cos(constants.animateBy);
    v.color = vertices.color;
    v.textureCoordinates = vertices.textureCoordinates;
    
    return v;
    
}

fragment float4 fragment_shader_texture(VertexOutTexture vIn [[stage_in]],
                                       texture2d<float> texture [[texture(0)]]){
   
    constexpr sampler defaultSampler;
    
    
    //    float4 color = colorTexture.sample(colorSampler, texcoord);
    //    if (color.a == 0.0) {
    //        discard_fragment();
    //    }
    float4 color = texture.sample(defaultSampler, vIn.textureCoordinates);
//        if (color.a == 0.0) {
//            discard_fragment();
//        }
    
    return color;
}

