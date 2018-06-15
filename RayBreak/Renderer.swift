

import MetalKit

class Renderer: NSObject {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue!
    var basePlane:BasicScene!
    var scenes: [Scene] = []
    var pointIndex: Int!
    let touchpoint:CGPoint = CGPoint(x: 0, y: 0)
    var lastPoint:CGPoint!
    var touchedArray = [DMETouch?](repeating:DMETouch(touchPoint: float3(0,0,0)), count: 3)
    
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
        basePlane = BasicScene(device: device, touchPoint: touchpoint)
        scenes.append(basePlane)
    }
    
    func changeTexture(texture:MTLTexture){
        var count:Int = 0
        for scene in scenes {
            if scene is TempScene{
                if count < scenes.count{
                    scenes.remove(at: count)
                    count += 0
                }
            }else{
                print("Base class")
                count += 1
                basePlane.changeTextureofthePlane(device: device, texture: texture)
            }
            
        }
        
    }
    
    func touchReceived(position:CGPoint , state: Int){
        
        scenes.append(TempScene(device: device, touchPoint: position))
        
        if state == 0 {
            print("drawing Started")
            pointIndex = 0
            lastPoint = position;
            print(touchedArray)
            touchedArray[pointIndex] = DMETouch(touchPoint: float3(Float(position.x),Float(position.y),0.0))
            print(touchedArray)
            
        }else if state == 1 {
            print("drawing Moving")
            let movedDistance:CGFloat = position.distance(toPoint: lastPoint);
            print("movedDistance:\(movedDistance)")
            pointIndex = pointIndex + 1
            lastPoint = position
            
            if pointIndex > 2 {
                
                if pointIndex % 2 == 1 {
                    
                }
            }
            
        }else {
            print("drawing Finished")
        }
        
    }
    
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        
        
        for scene in scenes{
            scene.render(commandEncoder: commandEncoder!, deltaTime: deltaTime)
        }
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
  
}

extension CGPoint {
    
    func distance(toPoint p:CGPoint) -> CGFloat {
        return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
    }
}


