
import MetalKit

class TempScene:Scene {
    
    //let plane :Plane!
 
    override init(device: MTLDevice, touchPoint:CGPoint) {
     
        
        super.init(device: device,touchPoint:touchPoint)
        appendChild(touchPoint: touchPoint)
        
    }
    
     func appendChild(touchPoint:CGPoint) {
 
        
//        let triangle = Triangle(device: super.device, color: float4(0.25,0.75,0.75,1.0),touchPoint:touchPoint)
//        add(child: triangle)
        
       let square = Square(device: super.device, color: float4(0.24,0.26,0.76,1.0),touchPoint:touchPoint, imageName: "waterColor.png")
        add(child: square)
   
        
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder , deltaTime: Float) {
        
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
    
}
