import MetalKit
import UIKit

enum Colors {
    static let wenderlichGreen = MTLClearColor(red: 0.0,
                                               green: 0.0,
                                               blue: 0.0,
                                               alpha: 1.0)
}



class ViewController: UIViewController {
    var touchPoint:CGPoint = CGPoint(x: 0, y: 0)
    var state:Int!
    
    var metalView: MTKView {
       
        return view as! MTKView
    }
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.framebufferOnly =  false
        metalView.preferredFramesPerSecond = 120
   
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device")
        }
        
        metalView.clearColor =  Colors.wenderlichGreen
        
        
        renderer = Renderer(device: device)
        setupGestures()

        metalView.delegate = renderer
        
        
    }
    
    
 
    
    func setupGestures(){
     
    }
    
    

    func convertCoodinates(tapx:CGFloat,tapy:CGFloat) -> CGPoint{
        
        let deviceWidth:CGFloat = CGFloat(self.view.frame.size.width)
        let deviceHeight:CGFloat = CGFloat(self.view.frame.size.height )
        
        var touchPoint:CGPoint = CGPoint(x: 0.0, y: 0.0)
        
        if (tapx <= deviceWidth/2) && (tapy <= deviceHeight/2) {
            touchPoint.x = (tapx / deviceWidth) * 2 - 1
            touchPoint.y = -(tapy / deviceHeight) * 2 + 1
        }else if (tapx > deviceWidth/2) && (tapy <= deviceHeight/2) {
            touchPoint.x = (tapx / deviceWidth) * 2 - 1
            touchPoint.y = -(tapy / deviceHeight) * 2 + 1
        }else if (tapx <= deviceWidth/2) && (tapy > deviceHeight/2) {
            touchPoint.x = (tapx / deviceWidth) * 2 - 1
            touchPoint.y = -(tapy / deviceHeight) * 2 + 1
        }else if (tapx > deviceWidth/2) && (tapy > deviceHeight/2) {
            touchPoint.x = (tapx / deviceWidth) * 2 - 1
            touchPoint.y = -(tapy / deviceHeight) * 2 + 1
        }
        
        return touchPoint
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        state = 0;
        for touch in (touches ){
            let location = touch.location(in: self.view)
            touchPoint = convertCoodinates(tapx:location.x , tapy:location.y )
            print("touchesBegan:\(touchPoint)")
            renderer?.touchReceived(position: touchPoint, state: state )
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
         state = 1;
        for touch in (touches ){
            let location = touch.location(in: self.view)
            touchPoint = convertCoodinates(tapx:location.x , tapy:location.y )
            print("touchesEnded:\(touchPoint)")
            renderer?.touchReceived(position: touchPoint, state: state)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = 2;
        super.touchesEnded(touches, with: event)
        for touch in (touches ){
            let location = touch.location(in: self.view)
            touchPoint = convertCoodinates(tapx:location.x , tapy:location.y )
             print("touchesEnded:\(touchPoint)")
            renderer?.touchReceived(position: touchPoint, state: state)
            
            let context = CIContext()
            let texture = metalView.currentDrawable!.texture
            let cImg = CIImage(mtlTexture: texture, options: nil)!
            let cgImg = context.createCGImage(cImg, from: cImg.extent)!
            let uiImg = UIImage(cgImage: cgImg)
            print("Texture width:\(texture.width) & height:\(texture.height)")
            
            
            guard let device = metalView.device else {
                fatalError("Device not created. Run on a physical device")
            }
            let textureLoader = MTKTextureLoader(device:device)
            let imageData: NSData = UIImagePNGRepresentation(uiImg)! as NSData
            let temTexture = try! textureLoader.newTexture(data: imageData as Data, options: [MTKTextureLoader.Option.allocateMipmaps : (false as NSNumber)])
            
            renderer?.changeTexture(texture: temTexture)
        }
    }

 

    
}



