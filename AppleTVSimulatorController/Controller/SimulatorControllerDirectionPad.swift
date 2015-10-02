//
//  SimulatorControllerDirectionPad.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/3/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import Foundation
import GameController

public class SimulatorControllerDirectionPad: GCControllerDirectionPad {
    private let simulatorUp = SimulatorControllerButtonInput()
    private let simulatorDown = SimulatorControllerButtonInput()
    private let simulatorLeft = SimulatorControllerButtonInput()
    private let simulatorRight = SimulatorControllerButtonInput()
    
    private let simulatorXAxis = SimulatorControllerAxisInput()
    private let simulatorYAxis = SimulatorControllerAxisInput()
    
    override init() {
        super.init()
        simulatorXAxis.dpad = self
        simulatorYAxis.dpad = self
    }
    
    private func adjustRawValue(var vector: CGVector) -> CGVector {
        // Try to appoximate the physical remote's saturation.
        vector.dx *= 1.75
        vector.dx = min(vector.dx, 1.0)
        vector.dx = max(vector.dx, -1.0)

        vector.dy *= 1.75
        vector.dy = min(vector.dy, 1.0)
        vector.dy = max(vector.dy, -1.0)
        
        return vector
    }
    
    private func updateAxisValue(axis: SimulatorControllerAxisInput, value: Float) -> Bool {
        let old = axis.simulatorValue
        axis.simulatorValue = value
        return old != value
    }
    
    func setPosition(var vector: CGVector) -> Bool {
        vector = adjustRawValue(vector)
        
        var changed = false
        changed = changed || updateAxisValue(simulatorXAxis, value: Float(vector.dx))
        changed = changed || updateAxisValue(simulatorYAxis, value: Float(vector.dy))
        
        // Button values are generated from axis values so we don't need to detect changes.
        // They change exactly when the axis values change.

        simulatorLeft.buttonValue = (vector.dx < 0) ? Float(abs(vector.dx)) : 0
        simulatorRight.buttonValue = (vector.dx > 0) ? Float(vector.dx) : 0
        simulatorUp.buttonValue = (vector.dy > 0) ? Float(vector.dy) : 0
        simulatorDown.buttonValue = (vector.dy < 0) ? Float(abs(vector.dy)) : 0
        
        return changed
    }
}

/**
 * GCControllerDirectionPad implementation
 */
extension SimulatorControllerDirectionPad {
    override public var xAxis: GCControllerAxisInput { return simulatorXAxis }
    override public var yAxis: GCControllerAxisInput { return simulatorYAxis }
    
    override public var up: GCControllerButtonInput { return simulatorUp }
    override public var down: GCControllerButtonInput { return simulatorDown }
    
    override public var left: GCControllerButtonInput { return simulatorLeft }
    override public var right: GCControllerButtonInput { return simulatorRight }
    
}
