# Apple TV Simulator Game Controller

In tvOS the Apple TV remote can act as a game controller and is accessed through the Game Controller framework. As of Xcode 7.1 beta 2, though, the Game Controller framework is not supported in the Apple TV Simulator. This project provides a GCController implementation that will work with the simulator for testing.
## Usage
Add the files in the Controller directory to your project. GameViewController.swift provides an example of how to integrate it. The following sections describe each step.
### Conditionally create controller
```
#if arch(i386) || arch(x86_64)
    scene.controller = createSimulatorController()
#else
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleControllerDidConnectNotification:", name: GCControllerDidConnectNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleControllerDidDisconnectNotification:", name: GCControllerDidDisconnectNotification, object: nil)
#endif
```
### Register gesture recognizers
The controller depends on a few gesture recognizers that you'll need to add to your view.
```
func createSimulatorController() -> SimulatorController {
        let controller = SimulatorController()
        controller.createGestureRecognizers().forEach { view.addGestureRecognizer($0) }
        return controller
}
```
### Forward touch events
You'll need to forward touch events to the controller.
```
#if arch(i386) || arch(x86_64)
override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    if let controller = scene?.controller as? SimulatorController {
        controller.pressesBegan(presses, withEvent: event)
    }
}
    
override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
}
    
override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    if let controller = scene?.controller as? SimulatorController {
        controller.pressesCancelled(presses, withEvent: event)
    }
}
    
override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    if let controller = scene?.controller as? SimulatorController {
        controller.pressesEnded(presses, withEvent: event)
    }
}
#endif
```
## Caveats
This is a work around to allow limited Game Controller testing with the Apple TV simulator until Apple provides that functionality. It is not a compelete implementation of the Game Controller classes. A few things not implemented are:

* GCController.handlerQueue: all callbacks are delivered on the same thread that feeds keyboard events and gestures to the controller
* GCController.motion: returns nil
## License
AppleTVSimulatorController is available under the MIT license. See the LICENSE file for more info.