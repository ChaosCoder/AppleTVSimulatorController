//
//  SimulatorControllerAxisInput.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/3/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import Foundation
import GameController

public class SimulatorControllerAxisInput: GCControllerAxisInput {
    var simulatorValue = Float(0) {
        didSet {
            if simulatorValue != oldValue {
                axisValueChangedHandler?(self, simulatorValue)
            }
        }
    }
    weak var dpad: SimulatorControllerDirectionPad?
    var axisValueChangedHandler: GCControllerAxisValueChangedHandler?
}

/**
 * GCControllerAxisInput implementation
 */
extension SimulatorControllerAxisInput {
    override public var value: Float { return simulatorValue }
    
    override public var valueChangedHandler: GCControllerAxisValueChangedHandler? {
        get {
            return axisValueChangedHandler
        }
        set {
            axisValueChangedHandler = newValue
        }
    }
    
    override public var collection: GCControllerElement? {
        return dpad
    }
}