import MetalKit

class BasicScene: Scene {

    let plane :Plane!
    let plane1 :Plane!
    let plane2 :Plane!
    let plane3 :Plane!
    let plane4 :Plane!
    let plane5 :Plane!
    
  //  let plane2 :Plane!
    
    
    override init(device: MTLDevice, touchPoint: CGPoint) {
      
        plane = Plane(device: device, imageName: "water-3.png")
        plane1 = Plane(device: device, imageName: "aa.jpg")
        plane2 = Plane(device: device, imageName: "water-3.png")
        plane3 = Plane(device: device, imageName: "water-3.png")
        plane4 = Plane(device: device, imageName: "water-3.png")
        plane5 = Plane(device: device, imageName: "water-3.png")
    //    plane2 = Plane(device: device, imageName: "pattern.png")
        super.init(device: device, touchPoint: touchPoint)
        
        add(child: plane1)
        add(child: plane)
         add(child: plane2)
         add(child: plane3)
        add(child: plane4)
         add(child: plane5)

     //   add(child: plane2)
        
       
    }
    
    
//    init(device: MTLDevice, touchPoint: CGPoint , texture: MTLTexture) {
//        <#code#>
//    }
    
    func changeTextureofthePlane(device: MTLDevice, texture:MTLTexture){
        plane.changeTexture(device: device, texture: texture)
    }
    
}

