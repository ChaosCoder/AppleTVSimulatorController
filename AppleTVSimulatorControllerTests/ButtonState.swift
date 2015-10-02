//
//  ButtonState.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/5/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import Foundation
import GameController

func ==(lhs: ButtonState, rhs: ButtonState) -> Bool {
    return lhs.button == rhs.button &&
    lhs.value == rhs.value &&
    lhs.pressed == rhs.pressed
}

struct ButtonState: Equatable {
    let button: GCControllerButtonInput
    let value: Float
    let pressed: Bool
}
