//
//  Texturable.swift
//  RayBreak
//
//  Created by 4Axis_Admin on 6/8/18.
//  Copyright © 2018 caroline. All rights reserved.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? {get set}
}

extension Texturable {
    func setTexture(device: MTLDevice , imageName: String) ->MTLTexture? {
        
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture? = nil
        
    
        
        let textureLoaderOptions: [String: NSObject]
        
        textureLoaderOptions = [:]
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture =  try textureLoader.newTexture(URL: textureURL, options: [:])
            }catch{
                print("issue Texturable here")
            }
        }
        return texture
    }
}
