//
//  Press.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/4/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import UIKit

/**
 * Press allows sending fake press events for testing.
 */
class Press: UIPress {
    var pressPhase: UIPressPhase
    var pressType: UIPressType
    
    override var phase: UIPressPhase { return pressPhase }
    override var type: UIPressType { return pressType }
    
    init(type: UIPressType, phase: UIPressPhase) {
        pressType = type
        pressPhase = phase
    }
    
    class func setWithType(type: UIPressType, phase: UIPressPhase) -> Set<Press> {
        return Set([Press(type: type, phase: phase)])
    }
}