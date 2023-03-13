//
//  SandStuff.swift
//  MementoMori
//
//  Created by Simon Lang on 13.03.23.
//

import Foundation
import SpriteKit

class Sandfall: SKScene {
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        
        // anchor point
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        
        // background color
        backgroundColor = .clear
        
        // creating a node and adding it to scene
        let node = SKEmitterNode(fileNamed: "SandParticles.sks")!
        addChild(node)
        
    }
}

class SandScatter: SKScene {
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        
        // anchor point
        anchorPoint = CGPoint(x: 0.5, y: 0.3)
        
        // background color
        backgroundColor = .clear
        
        // creating a node and adding it to scene
        let node = SKEmitterNode(fileNamed: "SandParticlesScatter.sks")!
        addChild(node)
        
    }
}
