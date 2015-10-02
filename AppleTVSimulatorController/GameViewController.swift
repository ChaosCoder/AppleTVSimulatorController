//
//  GameViewController.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/2/15.
//  Copyright (c) 2015 Chris Gulley. All rights reserved.
//

import UIKit
import SpriteKit
import GameController

class GameViewController: UIViewController {
    var scene: GameScene?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: GCControllerDidConnectNotification)
        NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: GCControllerDidDisconnectNotification)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            self.scene = scene
            
            #if arch(i386) || arch(x86_64)
                scene.controller = createSimulatorController()
            #else
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleControllerDidConnectNotification:", name: GCControllerDidConnectNotification, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleControllerDidDisconnectNotification:", name: GCControllerDidDisconnectNotification, object: nil)
            #endif
        }
    }

    #if arch(i386) || arch(x86_64)
    func createSimulatorController() -> SimulatorController {
        let controller = SimulatorController()
        controller.createGestureRecognizers().forEach { view.addGestureRecognizer($0) }
        return controller
    }
    #endif
    
    func handleControllerDidConnectNotification(notification: NSNotification) {
        if let controller = notification.object as? GCController, scene = self.scene {
            scene.controller = controller
        }
    }
    
    func handleControllerDidDisconnectNotification(notification: NSNotification) {
        if let scene = self.scene {
            scene.controller = nil
        }
    }
}
