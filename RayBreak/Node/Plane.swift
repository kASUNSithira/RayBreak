
import MetalKit

class Plane:Primitive {
    
    var texture: MTLTexture?
    var temporyDrawableImage :UIImage?
    var textureVertices:[TextureVertex]!
    var currentScaleFactor:Float = 1.0
    var previousScaleFactor:Float = 1.0
    var previousScaleFactorForOverZooming:Float = 1.0
    var resizeCanvasAfterInitialZooming:Bool = true
    var resizeCanvasWhenEverZoomingHappens = false
    var coordinateScaledRatio:Float = 1.0

    override var vertexDescriptor: MTLVertexDescriptor!{
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<TextureVertex>.stride
        
        return vertexDescriptor
    }
    
    override func buildVertices(){
        
        let size: Float = 1.0
        
        textureVertices = [TextureVertex(position: float3(-1,1 ,0), color: float4(0,0,0 ,0),texture:float2(0,0)),
                           TextureVertex(position: float3(-1, -1 ,0), color: float4(0,0,0 ,0),texture:float2(0,1)),
                           TextureVertex(position: float3(1, -1 ,0), color: float4(0,0,0 ,0),texture:float2(1,1)),
                           TextureVertex(position: float3( 1, 1 ,0), color: float4(0,0,0 ,0),texture:float2(1,0))
        ]
        
        indices = [
            0,1,2,
            2,3,0
        ]
        
    }
    
    init(device: MTLDevice , imageName : String) {
      
       super.init(device: device)

        vertexFunctionName = "vertex_shader_texture"
        fragmentFunctionName = "fragment_shader_texture"
        
        sceneConstants.projectionMatrix = matrix_float4x4(prespectiveDegreesFov:45, aspectRatio:Float(1536.0 / 2048.0),nearZ:0.1,farZ:100)
        
        modelConstants.modelMatrix.translate(direction: float3(0,0,-1))
        //modelConstants.modelMatrix.translate(direction: float3(Float(0.5),Float(0),Float(0)))
         modelConstants.modelMatrix.scale(axis: float3(0.5,0.5,0))
        //print("Model Matrix:\(modelConstants.modelMatrix.columns.3)")
       
        
        self.texture = setTexture(device: device, imageName: imageName)
       //self.texture = imageToTexture(imageNamed: imageName, device: device)
        
        buildVertices()
        buildBuffers(device: device)
        renderPipelineState =  buildPipelineState(device: device)
        
    }
   // MARK:update Canvas
    func updateCanvas(texture:MTLTexture )  {
         self.texture = texture
    }
  
 // MARK:
    func zoomCanvas(currentDrawableScaleFactor:Float) {
        modelConstants.modelMatrix.scale(axis: float3(currentDrawableScaleFactor,currentDrawableScaleFactor,1))
    }
    
    func rotateCanvas(rotation:Float){
        modelConstants.modelMatrix.rotate(angle:rotation, axis: float3(0,0,1))
    }
    
    func dargCanvas(axis:float3 ){
        modelConstants.modelMatrix.translate(direction: axis)
    }
    
    func modelConstant(modelConstants:ModelConstants){
        self.modelConstants = modelConstants
    }
    // MARK:Commands

    override func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: textureVertices!, length: (textureVertices?.count)! *   MemoryLayout<TextureVertex>.stride , options: [])
        
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count *  MemoryLayout<UInt16>.size, options: [])
    }
    
   override func draw(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setRenderPipelineState(renderPipelineState!)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
    
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<ScenceConstants>.stride, index: 2)
    
        commandEncoder.setFragmentTexture(texture, index: 0)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer!,
                                             indexBufferOffset:0)
    }
   
}


extension Plane: Texturable {
   
}







