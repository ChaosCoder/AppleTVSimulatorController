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
            scene.size = self.view.bounds.size
            
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
    
    // MARK: - Simulator methods
    #if arch(i386) || arch(x86_64)
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if let controller = scene?.controller as? SimulatorController {
            controller.pressesBegan(presses, withEvent: event)
        }
    }
    
    override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    }
    
    override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if let controller = scene?.controller as? SimulatorController {
            controller.pressesCancelled(presses, withEvent: event)
        }
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if let controller = scene?.controller as? SimulatorController {
            controller.pressesEnded(presses, withEvent: event)
        }
    }
    
    func createSimulatorController() -> SimulatorController {
        let controller = SimulatorController()
        controller.createGestureRecognizers().forEach { view.addGestureRecognizer($0) }
        return controller
    }
    #endif
}
