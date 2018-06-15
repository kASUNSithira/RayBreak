
import MetalKit

class Primitive: Node {
    
    //var pipelineState: MTLRenderPipelineState!

    var fragmentFunctionName: String
    var vertexFunctionName: String
    var vertexDescriptor: MTLVertexDescriptor! {
        let vertexDescriptor = MTLVertexDescriptor()

        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0

        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride

        return vertexDescriptor

    }

    var renderPipelineState : MTLRenderPipelineState!

    var vertices: [Vertex]!


    var indices: [UInt16]!

    var touchLocation: float2!

    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!

  //  var modelConstants = ModelConstants()
    
    init(device: MTLDevice) {
        
        vertexFunctionName = "vertex_shader"
        fragmentFunctionName = "fragment_shader"

        touchLocation = float2(0,0)


        super.init()
        buildVertices()
        buildBuffers(device: device)
        renderPipelineState =  buildPipelineState(device: device)
    }

    func buildVertices(){
    }

    func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices!, length: (vertices?.count)! *   MemoryLayout<Vertex>.stride , options: [])

        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count *  MemoryLayout<UInt16>.size, options: [])
    }


    private func buildPipelineState(device: MTLDevice) {





    }
//
//
//    func scale(axis: float3){
//      //  modelConstants.modelMatrix.scale(axis: axis)
//    }
//
//    func translate(direction: float3){
//      //  modelConstants.modelMatrix.translate(direction: direction)
//    }
//
//
//    func rotate(angle:Float , axis: float3){
//      //  modelConstants.modelMatrix.rotate(angle: angle, axis: axis)
//    }
//
    func touchLocation(currentTouchLocation:float2){

    }

    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {


        super.render(commandEncoder: commandEncoder, deltaTime:deltaTime)

    }

    func draw(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setRenderPipelineState(renderPipelineState!)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

   //     commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)

        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer!,
                                             indexBufferOffset:0)

    }

}


extension Primitive: Renderable {




}



