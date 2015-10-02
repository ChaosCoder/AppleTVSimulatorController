//
//  GamepadTests.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/5/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import XCTest
import GameController
@testable import AppleTVSimulatorController

class GamepadTests: XCTestCase {
    var controller: SimulatorController!
    
    override func setUp() {
        super.setUp()
        controller = SimulatorController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testButtonPressedCallback() {
        var valueChanged = false
        controller.microGamepad!.valueChangedHandler = { [unowned self] (gamepad, element) in
            valueChanged = true
            XCTAssert(gamepad === self.controller.microGamepad!, "Incorrect button in callback")
            XCTAssert(element === self.controller.microGamepad!.buttonA, "Incorrect button in callback")
        }
        
        controller.pressesBegan(Press.setWithType(.Select, phase: .Began), withEvent: nil)
        XCTAssert(valueChanged, "Button callback not called")
    }
    
    
    func testAxisChangedCallback() {
        var valueChanged = false
        controller.microGamepad!.valueChangedHandler = { [unowned self] (gamepad, element) in
            valueChanged = true
            XCTAssert(gamepad === self.controller.microGamepad!, "Incorrect button in callback")
            XCTAssert(element === self.controller.microGamepad!.dpad, "Incorrect button in callback")
        }

        controller.handlePan(PanGestureRecognizer(state: .Began, translation: CGPoint(x: 1920 / 2, y: 0)))
        XCTAssert(valueChanged, "Button callback not called")
    }
}
