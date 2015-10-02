//
//  GameScene.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/2/15.
//  Copyright (c) 2015 Chris Gulley. All rights reserved.
//

import SpriteKit
import GameController

class GameScene: SKScene {
    var gamePaused = false
    
    var controller: GCController? {
        didSet {
            configureController()
        }
    }
    var contentCreated = false
    
    override func didMoveToView(view: SKView) {
        guard !contentCreated else {
            return
        }
        
        
        contentCreated = true
    }
    
    func pause() {
        if gamePaused {
            if let label = childNodeWithName("PausedLabel") {
                label.removeFromParent()
                gamePaused = false
            }
        }
        else {
            let label = SKLabelNode(text: "Paused")
            label.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
            label.fontColor = SKColor.blackColor()
            label.fontSize = 60
            label.name = "PausedLabel"
            addChild(label)
            gamePaused = true
        }
    }
    
    func configureController() {
        guard let controller = controller else {
            return
        }
        
        controller.controllerPausedHandler = { [unowned self] _ in self.pause() }
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
}
