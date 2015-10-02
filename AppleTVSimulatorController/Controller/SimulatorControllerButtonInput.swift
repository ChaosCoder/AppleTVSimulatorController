//
//  SimulatorControllerButtonInput.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/2/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import Foundation
import GameController

public class SimulatorControllerButtonInput: GCControllerButtonInput {
    var buttonValue = Float(0) {
        didSet {
            if oldValue != buttonValue {
                buttonValueChangedHandler?(self, value, pressed)
            }
            
            let oldPressed = oldValue > 0
            if oldPressed != pressed {
                buttonPressedChangedHandler?(self, value, pressed)
            }
        }
    }
    
    var buttonPressedChangedHandler: GCControllerButtonValueChangedHandler?
    var buttonValueChangedHandler: GCControllerButtonValueChangedHandler?
}

/**
 * GCControllerButtonInput implementation
 */
extension SimulatorControllerButtonInput {
    override public var pressed: Bool { return buttonValue > 0 }
    override public var value: Float { return buttonValue }
    override public var pressedChangedHandler: GCControllerButtonValueChangedHandler? {
        get {
            return buttonPressedChangedHandler
        }
        set {
            buttonPressedChangedHandler = newValue
        }
    }
    
    override public var valueChangedHandler: GCControllerButtonValueChangedHandler? {
        get {
            return buttonValueChangedHandler
        }
        set {
            buttonValueChangedHandler = newValue
        }
    }
}
