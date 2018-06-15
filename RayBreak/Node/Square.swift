import MetalKit

class Square: Primitive {
    
    var color: float4!
    var touchpoint:CGPoint!
    
    var texture: MTLTexture?
    var textureVertices:[TextureVertex]!
    let brushThickness:CGFloat =  0.04
    
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
    
    private func genarateVertices(touchPoint:CGPoint) ->(a:CGPoint ,b:CGPoint, c:CGPoint, d:CGPoint){
        
        let vertex_a:CGPoint = CGPoint(x: touchPoint.x - brushThickness, y: touchPoint.y + brushThickness)
        let vertex_b:CGPoint = CGPoint(x: touchPoint.x - brushThickness, y: touchPoint.y - brushThickness)
        let vertex_c:CGPoint = CGPoint(x: touchPoint.x + brushThickness, y: touchPoint.y - brushThickness)
        let vertex_d:CGPoint = CGPoint(x: touchPoint.x + brushThickness, y: touchPoint.y + brushThickness)
        
        return (vertex_a,vertex_b,vertex_c,vertex_d)
    }
    
    override func buildVertices(){
        
        let generateVertices = genarateVertices(touchPoint: touchpoint)
        
        
    textureVertices = [TextureVertex(position: float3(Float(generateVertices.a.x),Float(generateVertices.a.y) ,0), color:self.color ,texture:float2(0.0,0.0)),
                    TextureVertex(position: float3(Float(generateVertices.b.x),Float(generateVertices.b.y),0), color: color ,texture:float2(0.0,1.0)),
                           TextureVertex(position: float3(Float(generateVertices.c.x),Float(generateVertices.c.y) ,0), color: color ,texture:float2(1.0,1.0)),
                           TextureVertex(position: float3(Float(generateVertices.d.x),Float(generateVertices.d.y) ,0), color: color ,texture:float2(1.0,0.0))
            
        ]
        
        indices = [
            0,1,2,
            2,3,0
        ]
        
    }
    
    init(device: MTLDevice, color:float4, touchPoint:CGPoint,imageName:String) {
        
        self.color = color
        self.touchpoint = touchPoint
        super.init(device: device)
        
        vertexFunctionName = "vertex_shader_3DBrush"
        fragmentFunctionName = "fragment_shader_3DBrush"
     
        self.texture = setTexture(device: device, imageName: imageName)
        self.texture = imageToTexture(imageNamed: imageName, device: device)
      
        buildVertices()
        buildBuffers(device: device)
        renderPipelineState =  buildPipelineState(device: device)
    }
    
   
    override func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: textureVertices!, length: (textureVertices?.count)! *   MemoryLayout<TextureVertex>.stride , options: [])
        
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count *  MemoryLayout<UInt16>.size, options: [])
    }
    
    override func draw(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setRenderPipelineState(renderPipelineState!)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
      
        commandEncoder.setFragmentTexture(texture, index: 0)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer!,
                                             indexBufferOffset:0)
    }
    
    func imageToTexture(imageNamed: String, device: MTLDevice) -> MTLTexture {
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        
        var image = UIImage(named: imageNamed)!
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        let bounds = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        var rowBytes = width * bytesPerPixel
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: rowBytes, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue)
        
        context!.clear(bounds)
        context?.translateBy(x: CGFloat(width), y: CGFloat(height))
        //  CGContextTranslateCTM(context!, CGFloat(width), CGFloat(height))
        context?.scaleBy(x: -1.0, y: -1.0)
        //   CGContextScaleCTM(context!, -1.0, -1.0)
        context?.draw(image.cgImage!, in: bounds)
        //  CGContextDrawImage(context, bounds, image.CGImage)
        
        var texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        
        var texture = device.makeTexture(descriptor: texDescriptor)
        texture?.label = imageNamed
        
        // var pixelsData = CGBitmapContextGetData(context!)
        var pixelsData = context?.data
        var region = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: pixelsData!, bytesPerRow: rowBytes)
        
        return texture!
    }
    
    
    
}
extension Square: Texturable {
    
    
    
}
