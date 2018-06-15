//
//  Triangle.swift
//  RayBreak
//
//  Created by 4Axis_Admin on 6/4/18.
//  Copyright © 2018 caroline. All rights reserved.
//


import MetalKit

class Triangle:Primitive {
    
    var color: float4!
    var touchpoint:CGPoint!
    
    init(device: MTLDevice, color:float4, touchPoint:CGPoint) {
        
        self.color = color
        self.touchpoint = touchPoint
        super.init(device: device)
        
    }
    
    static let coordinateRange : Float = 1.0
    
    private func makeRandCoord() -> Float {
        return (Float(arc4random_uniform(1000000)) / 500000.0 - 1.0) * Triangle.coordinateRange
    }
    
    private func genarateVertices(touchPoint:CGPoint) ->(a:CGPoint ,b:CGPoint, c:CGPoint){
        
        let vertex_a:CGPoint = CGPoint(x: touchPoint.x, y: touchPoint.y + 0.04)
        let vertex_b:CGPoint = CGPoint(x: touchPoint.x - 0.04, y: touchPoint.y - 0.02)
        let vertex_c:CGPoint = CGPoint(x: touchPoint.x + 0.04, y: touchPoint.y - 0.02)
        
        return (vertex_a,vertex_b,vertex_c)
    }
    
    override func buildVertices(){
        
//        let size: Float = 0.4
//
//        vertices = [Vertex(position: float3(touchLocation.x,touchLocation.y ,0), color: color),
//                    Vertex(position: float3(-makeRandCoord(), makeRandCoord() ,0), color: color),
//                    Vertex(position: float3(-makeRandCoord(), -makeRandCoord() ,0), color: color),
//        ]
        
        let generateVertices = genarateVertices(touchPoint: touchpoint)

        vertices = [Vertex(position: float3(Float(generateVertices.a.x),Float(generateVertices.a.y) ,0), color: color),
                    Vertex(position: float3(Float(generateVertices.b.x),Float(generateVertices.b.y),0), color: color),
                    Vertex(position: float3(Float(generateVertices.c.x),Float(generateVertices.c.y) ,0), color: color),
        ]

        indices = [
            0,1,2,
        ]
        
    }
    
    override func touchLocation(currentTouchLocation: float2) {
        touchLocation = touchLocation
    }
}
