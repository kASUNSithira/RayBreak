import MetalKit

class BasicScene: Scene {

    let plane :Plane!
    
    override init(device: MTLDevice, touchPoint: CGPoint) {
      
        plane = Plane(device: device, imageName: "aa.jpg")
        super.init(device: device, touchPoint: touchPoint)
        
        
        add(child: plane)
    }
    
   
    
    func updateCanvas(texture:MTLTexture)  {
        plane.updateCanvas( texture: texture)
    }
    
    
    func zoomCanvas(currentDrawableScaleFactor:Float)  {
        plane.zoomCanvas(currentDrawableScaleFactor: currentDrawableScaleFactor)
    }
    
    func rotateCanvas(rotation:Float){
        plane.rotateCanvas(rotation: rotation)
    }
    
    func dargCanvas(axis:float3){
        plane.dargCanvas(axis: axis)
    }
    
    func modelConstant(modelConstants:ModelConstants){
       plane.modelConstant(modelConstants: modelConstants)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder , deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
    
}

