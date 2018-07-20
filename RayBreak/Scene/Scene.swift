import MetalKit

class Scene: Node {
    
    var device:MTLDevice!
    var touchPoint:CGPoint!
    var sceneConstants = ScenceConstants()
    
    init(device: MTLDevice , touchPoint:CGPoint) {
        self.device = device
        self.touchPoint = touchPoint
        super.init()
        sceneConstants.projectionMatrix = matrix_float4x4(prespectiveDegreesFov:45, aspectRatio:Float(1.0),nearZ:0.1,farZ:100)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder , deltaTime: Float) {
       // commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<ScenceConstants>.stride, index: 2)
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
    
    func tapReceived(){
        
    }

}
