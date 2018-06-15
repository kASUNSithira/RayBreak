//
//  Renderable.swift
//  RayBreak
//
//  Created by 4Axis_Admin on 6/8/18.
//  Copyright © 2018 caroline. All rights reserved.
//

import MetalKit

protocol Renderable {
    
    var fragmentFunctionName: String {get set}
    var vertexFunctionName: String{get set}
    var vertexDescriptor: MTLVertexDescriptor! { get }
    
    var renderPipelineState : MTLRenderPipelineState! { get set}
    
    func draw(commandEncoder: MTLRenderCommandEncoder)
}


extension Renderable{
    
    func buildPipelineState(device :MTLDevice) -> MTLRenderPipelineState {
        
        let library = device.makeDefaultLibrary()
        let vertexFunction  = library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: fragmentFunctionName)
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

       
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .one
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        
        var renderPipelineState: MTLRenderPipelineState! = nil
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }catch let error as NSError{
            print(error)
        }
        
        return renderPipelineState
    }
}
