import MetalKit

class BasicScene: Scene {

    let plane :Plane!
   // let plane1 :Plane!
    
    
    override init(device: MTLDevice, touchPoint: CGPoint) {
      
        plane = Plane(device: device, imageName: "aa.jpg")
        
      //  plane1 = Plane(device: device, imageName: "water-3")
        
        super.init(device: device, touchPoint: touchPoint)
        
        add(child: plane)
      //  add(child: plane1)
    }
    
    
    func changeTextureofthePlane(device: MTLDevice, texture:MTLTexture){
        plane.changeTexture(device: device, texture: texture)
    }
    
}

