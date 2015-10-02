//
//  PanGestureRecognizer.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/5/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import Foundation
import UIKit

class PanGestureRecognizer: UIPanGestureRecognizer {
    let translation: CGPoint
    let recognizerState: UIGestureRecognizerState
    override var state: UIGestureRecognizerState { return recognizerState }
    
    init(state: UIGestureRecognizerState, translation: CGPoint) {
        recognizerState = state
        self.translation = translation
        super.init(target: nil, action:"")
    }
    
    override func translationInView(view: UIView?) -> CGPoint {
        return translation
    }
}