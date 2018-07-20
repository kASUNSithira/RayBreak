import MetalKit
import UIKit
import Accelerate
import  GLKit

enum Colors {
    static let wenderlichGreen = MTLClearColor(red: 1.0,
                                               green: 1.0,
                                               blue: 1.0,
                                               alpha: 1.0)
}



class ViewController: UIViewController {
    var touchPoint:CGPoint = CGPoint(x: 0, y: 0)
    var state:Int = 0
    var currentDrawableScaleFactor:CGFloat = 1.0
    var currentDrawableScaleAdjustedFactor:CGFloat = 1.0
    var currentDrawableScalefactorIsLessThanOne = false
    var previousScaleFactor:CGFloat = 1.0
    var previousScaleAdjustedFactor:CGFloat = 1.0
    var translationFactor : CGPoint = CGPoint(x: 0, y: 0)
    var translationScaledFactor : CGPoint = CGPoint(x: 0, y: 0)
    
    var previousLocation:CGPoint = CGPoint(x: 0, y: 0)
    var singletapReceived = false
    
    var lastPoint:CGPoint!
    var temTexture:MTLTexture!
    private var modelConstants = ModelConstants()
    private var initialModelConstants = ModelConstants()
    private var transformationMatrix = TransformationMatrix()

    
    
    var adjutScaleRatio = true
    var panningDistance:CGFloat = 0.0
    
    
    var metalView: MTKView {
        
        return view as! MTKView
    }
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.framebufferOnly =  false
        metalView.preferredFramesPerSecond = 120
        metalView.autoResizeDrawable = false
        
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device")
        }
      
        metalView.clearColor =  Colors.wenderlichGreen
        
        renderer = Renderer(device: device)
        setupGestures()
        
        metalView.delegate = renderer
        self.temTexture = metalView.currentDrawable?.texture
        print("initial model constant:\(initialModelConstants)")
        
        transformationMatrix.transformationMatrix = GLKMatrix4Identity
        
        print("transformation Matrix:\(transformationMatrix.transformationMatrix.__Anonymous_field0)")
        
    }


    func setupGestures(){
        
       
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.rotate))
        self.view.addGestureRecognizer(rotate)
        
        self.view.isUserInteractionEnabled = true
        
    }
    

    
    
    @objc func rotate(rotateGesture: UIRotationGestureRecognizer){
        
        guard rotateGesture.view != nil else { return }
        
        if rotateGesture.state == UIGestureRecognizerState.changed {
            print("rotation:\(rotateGesture.rotation)")
            renderer?.rotateCanvas(rotation:Float(rotateGesture.rotation))
            modelConstants.modelMatrix.rotate(angle: Float(rotateGesture.rotation), axis: float3(0,0,1))
            print("Model Matrix:\(modelConstants.modelMatrix)")
            
            transformationMatrix.transformationMatrix = GLKMatrix4RotateZ(transformationMatrix.transformationMatrix, Float(0.1))
             print("transformation Matrix:\(transformationMatrix.transformationMatrix.__Anonymous_field0)")
            
            rotateGesture.rotation = 0
        } else if rotateGesture.state == UIGestureRecognizerState.began {
            
        }else if rotateGesture.state == UIGestureRecognizerState.ended{

        }
    }
    
   


   
  

    // MARK: - Coordinate Conversion
    
    func convertCoodinates(tapx:CGFloat,tapy:CGFloat) -> CGPoint{
        
        print("touch position:\(tapx) ...\(tapy)")
        
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
  
   
  
    

    
}



