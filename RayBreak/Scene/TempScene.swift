
import MetalKit

class TempScene:Scene {
    
    //let plane :Plane!
    let redColorComponent:Float = 0.26
    let greenColorComponent:Float = 0.47
    let blueColorComponent:Float = 0.84
    let opacity:Float = 1.0
    
 
    override init(device: MTLDevice, touchPoint:CGPoint) {
     
        
        super.init(device: device,touchPoint:touchPoint)
        appendChild(touchPoint: touchPoint)
        
    }
    
     func appendChild(touchPoint:CGPoint) {
 
//        let triangle = Triangle(device: super.device, color: float4(0.25,0.75,0.75,1.0),touchPoint:touchPoint)
//        add(child: triangle)
        
       let square = Square(device: super.device, color: float4(redColorComponent,greenColorComponent,blueColorComponent,opacity),touchPoint:touchPoint, imageName: "water-mask.png")
        add(child: square)
   
        
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder , deltaTime: Float) {
        
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
    
}
