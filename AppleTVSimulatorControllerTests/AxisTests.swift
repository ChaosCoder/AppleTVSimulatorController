//
//  AxisTests.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/5/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import XCTest
import GameController
@testable import AppleTVSimulatorController

class AxisTests: XCTestCase {
    var controller: SimulatorController!
    
    override func setUp() {
        super.setUp()
        controller = SimulatorController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func getDirectionKeys() -> (GCControllerButtonInput, GCControllerButtonInput, GCControllerButtonInput, GCControllerButtonInput) {
        let left = controller.microGamepad!.dpad.left
        let right = controller.microGamepad!.dpad.right
        let up = controller.microGamepad!.dpad.up
        let down = controller.microGamepad!.dpad.down
        return (left, right, up, down)
    }
    
    func validateDpadButtons(translation: CGPoint, expected: (left: Bool, right: Bool, up: Bool, down: Bool)) {
        controller.handlePan(PanGestureRecognizer(state: .Began, translation: translation))
        
        let (left, right, up, down) = getDirectionKeys()
        XCTAssertEqual(left.pressed, expected.left, "left button state incorrect")
        XCTAssertEqual(right.pressed, expected.right, "left button state incorrect")
        XCTAssertEqual(up.pressed, expected.up, "left button state incorrect")
        XCTAssertEqual(down.pressed, expected.down, "left button state incorrect")
    }
    
    func getAxes() -> (GCControllerAxisInput, GCControllerAxisInput) {
        let x = controller.microGamepad!.dpad.xAxis
        let y = controller.microGamepad!.dpad.yAxis
        return (x, y)
    }
    
    func validateAxesValues(translation: CGPoint, expected: (x: Float, y: Float)) {
        controller.handlePan(PanGestureRecognizer(state: .Began, translation: translation))
        
        let (x, y) = getAxes()
        XCTAssertEqual(x.value, expected.x, "x value incorrect")
        XCTAssertEqual(y.value, expected.y, "y value incorrect")
    }
    
    func testNeutralPosition() {
        let translation = CGPoint.zero
        
        let expectedButtons = (left: false, right: false, up: false, down: false)
        validateDpadButtons(translation, expected: expectedButtons)
        
        let expectedAxes: (Float, Float) = (0, 0)
        validateAxesValues(translation, expected: expectedAxes)
    }
    
    // All of these axes tests assume that we are feeding a translation beyond the saturation
    // level so that the axis value is 1
    func testLeftPosition() {
        let translation = CGPoint(x: -1920 / 2, y: 0)
        
        let expectedButtons = (left: true, right: false, up: false, down: false)
        validateDpadButtons(translation, expected: expectedButtons)
        
        let expectedAxes: (Float, Float) = (-1, 0)
        validateAxesValues(translation, expected: expectedAxes)
        
    }
    
    func testRightPosition() {
        let translation = CGPoint(x: 1920 / 2, y: 0)
        
        let expectedButtons = (left: false, right: true, up: false, down: false)
        validateDpadButtons(translation, expected: expectedButtons)
        
        let expectedAxes: (Float, Float) = (1, 0)
        validateAxesValues(translation, expected: expectedAxes)
    }
    
    func testUpPosition() {
        let translation = CGPoint(x: 0, y: -1080 / 2)
        
        let expectedButtons = (left: false, right: false, up: true, down: false)
        validateDpadButtons(translation, expected: expectedButtons)
        
        let expectedAxes: (Float, Float) = (0, 1)
        validateAxesValues(translation, expected: expectedAxes)
    }
    
    func testDownPosition() {
        let translation = CGPoint(x: 0, y: 1080 / 2)
        
        let expectedButtons = (left: false, right: false, up: false, down: true)
        validateDpadButtons(translation, expected: expectedButtons)
        
        let expectedAxes: (Float, Float) = (0, -1)
        validateAxesValues(translation, expected: expectedAxes)
    }
    
    func testAxisCallback() {
        var handlerCalled = false
        controller.microGamepad!.dpad.xAxis.valueChangedHandler = { (axis, value) in
            handlerCalled = true
        }
        
        controller.handlePan(PanGestureRecognizer(state: .Began, translation: CGPoint(x: 1920 / 2, y: 0)))
        XCTAssert(handlerCalled, "Axis callback not called")
    }
    
    func testButtonCallback() {
        var handlerCalled = false
        controller.microGamepad!.dpad.up.valueChangedHandler = { (controller, value, pressed) in
            handlerCalled = true
        }
        
        controller.handlePan(PanGestureRecognizer(state: .Began, translation: CGPoint(x: 0, y: -1080 / 2)))
        XCTAssert(handlerCalled, "Button callback not called")
    }
}
