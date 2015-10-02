//
//  SimulatorController.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/2/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import GameController

public class SimulatorController: GCController {
    // This property is overriden because using GCController's version
    // causes NSInternalInconsistencyException to get thrown.
    private var _controllerPausedHandler: ((GCController) -> Void)?
    override public var controllerPausedHandler: ((GCController) -> Void)? {
        get {
            return _controllerPausedHandler
        }
        
        set {
            _controllerPausedHandler = newValue
        }
    }
    
    override public var handlerQueue: dispatch_queue_t {
        get {
            return dispatch_get_main_queue()
        }
        
        set {
            fatalError("handlerQueue unimplemented")
        }
    }
    
    func createGestureRecognizers() -> [UIGestureRecognizer] {
        var recognizers = [UIGestureRecognizer]()
        
        let menu = UITapGestureRecognizer(target: self, action: "menuPressed:")
        menu.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        recognizers.append(menu)
        
        return recognizers
    }

    func menuPressed(recognizer: AnyObject) {
        if let handler = controllerPausedHandler {
            handler(self)
        }
    }
}
