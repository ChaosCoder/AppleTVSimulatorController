//
//  SimulatorMicroGamepad.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/2/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import UIKit
import GameController

public class SimulatorMicroGamepad: GCMicroGamepad {
    enum Button { case A, X }
    
    weak var simulatorController:SimulatorController?
    private let simulatorButtonA = SimulatorControllerButtonInput()
    private let simulatorButtonX = SimulatorControllerButtonInput()
    private let simulatorDpad = SimulatorControllerDirectionPad()
    
    var simulatorValueChangedHandler: GCMicroGamepadValueChangedHandler?
    
    func updateButtonValue(button: Button, value: Float) {
        switch button {
        case .A:
            updateButton(simulatorButtonA, value: value)
        case .X:
            updateButton(simulatorButtonX, value: value)
        }
    }
    
    private func updateButton(button: SimulatorControllerButtonInput, value: Float) {
        let old = button.buttonValue
        button.buttonValue = value
        if old != value {
            simulatorValueChangedHandler?(self, button)
        }
    }
    
    func updatePosition(vector: CGVector) {
        let changed = simulatorDpad.setPosition(vector)
        if changed {
            simulatorValueChangedHandler?(self, simulatorDpad)
        }
    }
}

/**
 * GCMicroGamepad implementation
 */
extension SimulatorMicroGamepad {
    override public var controller: GCController? { return simulatorController }
    override public var buttonA: GCControllerButtonInput { return simulatorButtonA }
    override public var buttonX: GCControllerButtonInput { return simulatorButtonX }
    override public var dpad: GCControllerDirectionPad { return simulatorDpad }
    
    override public var valueChangedHandler: GCMicroGamepadValueChangedHandler? {
        get {
            return simulatorValueChangedHandler
        }
        set {
            simulatorValueChangedHandler = newValue
        }
    }
}
