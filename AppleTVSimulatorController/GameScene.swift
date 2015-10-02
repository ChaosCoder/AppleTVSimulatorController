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
        
        let labels = ["ButtonStatusA", "ButtonStatusX", "AxisStatusX", "AxisStatusY", "DpadLeft", "DpadRight", "DpadUp", "DpadDown"]
        for (i, name) in labels.enumerate() {
            let label = SKLabelNode()
            label.name = name
            label.fontColor = SKColor.blackColor()
            label.fontSize = 50
            label.horizontalAlignmentMode = .Left
            label.verticalAlignmentMode = .Top
            label.position = CGPoint(x: 60, y: CGRectGetMaxY(frame) - 60 - CGFloat(i) * 70)
            addChild(label)
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
        controller.microGamepad!.buttonA.pressedChangedHandler = { [unowned self] (button, value, pressed) in
            self.updateButtonStatus(controller)
        }
        controller.microGamepad!.buttonX.pressedChangedHandler = { [unowned self] (button, value, pressed) in
            self.updateButtonStatus(controller)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        guard let controller = controller else {
            return
        }
        
        updateButtonStatus(controller)
        updateDpadStatus(controller)
    }
    
    func updateButtonStatus(controller: GCController) {
        let buttonA = controller.microGamepad!.buttonA
        let buttonX = controller.microGamepad!.buttonX
        let updates: [(name: String, status: Bool, value: Float, title: String)] = [
            ("ButtonStatusA", buttonA.pressed, buttonA.value, "Button A"),
            ("ButtonStatusX", buttonX.pressed, buttonX.value, "Button X")
        ]
        
        for update in updates {
            if let label = childNodeWithName(update.name) as? SKLabelNode {
                label.text = "\(update.title): \(update.status, update.value)"
                label.fontColor = update.status ? SKColor.redColor() : SKColor.blackColor()
            }
        }
    }
    
    func updateDpadStatus(controller: GCController) {
        let axisX = controller.microGamepad!.dpad.xAxis
        let axisY = controller.microGamepad!.dpad.yAxis
        let updates: [(name: String, value: Float, title: String)] = [
            ("AxisStatusX", axisX.value, "X Axis"),
            ("AxisStatusY", axisY.value, "Y Axis")
        ]

        for update in updates {
            if let label = childNodeWithName(update.name) as? SKLabelNode {
                label.text = "\(update.title): \(update.value)"
            }
        }
        
        let left = controller.microGamepad!.dpad.left
        let right = controller.microGamepad!.dpad.right
        let up = controller.microGamepad!.dpad.up
        let down = controller.microGamepad!.dpad.down
        let inputs: [(name: String, pressed: Bool, value: Float, title: String)] = [
            ("DpadLeft", left.pressed, left.value, "Dpad Left:"),
            ("DpadRight", right.pressed, right.value, "Dpad Right:"),
            ("DpadUp", up.pressed, up.value, "Dpad Up:"),
            ("DpadDown", down.pressed, down.value, "Dpad Down:")
        ]

        for input in inputs {
            if let label = childNodeWithName(input.name) as? SKLabelNode {
                label.text = "\(input.title): (\(input.pressed), \(input.value))"
            }
        }
    }
}
