//
//  SimulatorController.swift
//  AppleTVSimulatorController
//
//  Created by Chris Gulley on 10/2/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import GameController

public class SimulatorController: GCController {
    static var simulatorControllers = [GCController]()
    let simulatorGamepad = SimulatorMicroGamepad()
    let keymap: Dictionary<UIPressType, SimulatorMicroGamepad.Button>
    
    // We have to provide our own versions of some stored properties because using
    // the inherited versions cause NSInternalInconsistencyException to get thrown.
    var simulatorControllerPausedHandler: ((GCController) -> Void)?
    var simulatorPlayerIndex: GCControllerPlayerIndex = .IndexUnset
    
    override init() {
        keymap = [
            .Select: .A,
            .PlayPause: .X
        ]

        super.init()
        simulatorGamepad.simulatorController = self
    }
    
    deinit {
        SimulatorController.simulatorControllers = SimulatorController.simulatorControllers.filter { $0 !== self }
    }
}

/**
 * Button and touch handling
 */
extension SimulatorController {
    func createGestureRecognizers() -> [UIGestureRecognizer] {
        var recognizers = [UIGestureRecognizer]()
        
        // We can get the menu button with a gesture recognizer, but it looks like
        // have to rely on UIResponder methods on the view controller to get the
        // other buttons
        let menu = UITapGestureRecognizer(target: self, action: "menuPressed:")
        menu.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        recognizers.append(menu)
        
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizers.append(pan)
        
        return recognizers
    }
    
    func menuPressed(recognizer: AnyObject) {
        if let handler = controllerPausedHandler {
            handler(self)
        }
    }
    
    func normalizePanGesture(vector: CGVector) -> CGVector {
        // On the simulator there isn't a way to get an absolute position so we
        // don't really know what a reasonable range is for normalizing the touch,
        // i.e., we don't know if they started the touch close to the edge or not.
        // We'll just use values assuming the close is touch to the middle.
        var dx = vector.dx / (1920 / 2)
        dx = max(dx, -1)
        dx = min(dx, 1)
        
        var dy = -1 * vector.dy / (1080 / 2)
        dy = max(dy, -1)
        dy = min(dy, 1)
        
        return CGVector(dx: dx, dy: dy)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began, .Changed:
            let xlat = recognizer.translationInView(recognizer.view)
            let vector = normalizePanGesture(CGVector(dx: xlat.x, dy: xlat.y))
            simulatorGamepad.updatePosition(vector)
            
        case .Ended, .Cancelled:
            simulatorGamepad.updatePosition(CGVector.zero)
            
        default:
            break
        }
    }
    
    func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        guard let press = presses.first, button = keymap[press.type] else{
            return
        }
        simulatorGamepad.updateButtonValue(button, value: 1.0)
    }
    
    func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        guard let press = presses.first, button = keymap[press.type] else{
            return
        }
        simulatorGamepad.updateButtonValue(button, value: 0.0)
    }
    
    func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        guard let press = presses.first, button = keymap[press.type] else{
            return
        }
        simulatorGamepad.updateButtonValue(button, value: 0.0)
    }
}

/**
 * GCController implementation
 */
extension SimulatorController {
    override public class func controllers() -> [GCController] {
        return SimulatorController.simulatorControllers
    }
    
    override public var controllerPausedHandler: ((GCController) -> Void)? {
        get { return simulatorControllerPausedHandler }
        set { simulatorControllerPausedHandler = newValue }
    }
    
    override public var handlerQueue: dispatch_queue_t {
        get { return dispatch_get_main_queue() }
        set { fatalError("handlerQueue unimplemented") }
    }
    
    override public var vendorName: String? {
        return "SimulatorRemote"
    }
    
    override public var attachedToDevice: Bool {
        return false
    }
    
    override public var playerIndex: GCControllerPlayerIndex {
        get { return simulatorPlayerIndex }
        set { simulatorPlayerIndex = newValue }
    }
    
    override public var gamepad: GCGamepad? { return nil }
    override public var microGamepad: GCMicroGamepad? { return simulatorGamepad }
    override public var extendedGamepad: GCExtendedGamepad? { return nil }
    
    // The real remote returns a GCMotion instance but there's not much
    // we can do with it from the simulator.
    override public var motion: GCMotion? { return nil }
}