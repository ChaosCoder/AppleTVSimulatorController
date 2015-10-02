//
//  ButtonTests.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/5/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import XCTest
import GameController
@testable import AppleTVSimulatorController

class ButtonTests: XCTestCase {
    var controller: SimulatorController!
    var handlerCalled = false
    
    override func setUp() {
        super.setUp()
        controller = SimulatorController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func createButtonInputCallback(button: GCControllerButtonInput, value: Float, pressed: Bool) -> GCControllerButtonValueChangedHandler {
        handlerCalled = false
        let expected = ButtonState(button: button, value: value, pressed: pressed)
        return { [unowned self] (button, value, pressed) in
            self.handlerCalled = true
            let received = ButtonState(button: button, value: value, pressed: pressed)
            XCTAssertEqual(expected, received, "Wrong button state in callback")
        }
    }
    
    func testButtonAPressedCallback() {
        buttonPressedCallbackTest(controller.microGamepad!.buttonA, type: .Select)
    }
    
    func testButtonXPressedCallback() {
        buttonPressedCallbackTest(controller.microGamepad!.buttonX, type: .PlayPause)
    }
    
    func buttonPressedCallbackTest(button: GCControllerButtonInput, type: UIPressType) {
        button.pressedChangedHandler = createButtonInputCallback(button, value: 1.0, pressed: true)
        controller.pressesBegan(Press.setWithType(type, phase: .Began), withEvent: nil)
        XCTAssert(handlerCalled, "Button callback not called")
        
        button.pressedChangedHandler = createButtonInputCallback(button, value: 0.0, pressed: false)
        controller.pressesEnded(Press.setWithType(type, phase: .Ended), withEvent: nil)
        XCTAssert(handlerCalled, "Button callback not called")
    }
    
    func testButtonAValueChangedCallback() {
        buttonValueChangedCallbackText(controller.microGamepad!.buttonA, type: .Select)
    }
    
    func testButtonXValueChangedCallback() {
        buttonValueChangedCallbackText(controller.microGamepad!.buttonX, type: .PlayPause)
    }
    
    func buttonValueChangedCallbackText(button: GCControllerButtonInput, type: UIPressType) {
        button.valueChangedHandler = createButtonInputCallback(button, value: 1.0, pressed: true)
        controller.pressesBegan(Press.setWithType(type, phase: .Began), withEvent: nil)
        XCTAssert(handlerCalled, "Button callback not called")
        
        button.valueChangedHandler = createButtonInputCallback(button, value: 0.0, pressed: false)
        controller.pressesEnded(Press.setWithType(type, phase: .Ended), withEvent: nil)
        XCTAssert(handlerCalled, "Button callback not called")
    }}
