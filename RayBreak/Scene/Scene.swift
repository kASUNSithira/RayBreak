import MetalKit

class Scene: Node {
    
    var device:MTLDevice!
    var touchPoint:CGPoint!
    init(device: MTLDevice , touchPoint:CGPoint) {
        self.device = device
        self.touchPoint = touchPoint
        super.init()
       
    }
    
    
    func tapReceived(){
        
    }
    
    
}
