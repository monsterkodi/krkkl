
import Cocoa
import ScreenSaver

@NSApplicationMain
class AppDelegate: NSObject {
    
    @IBOutlet var window: NSWindow!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(notification: NSNotification) {

        let view = KrkklView(frame: CGRectZero, isPreview: false)
        view.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable

        view.frame = window.contentView.bounds
        window.contentView.addSubview(view)
        
        // Start animating the clock
        view.startAnimation()
        NSTimer.scheduledTimerWithTimeInterval(view.animationTimeInterval(), target: view, selector: "animateOneFrame", userInfo: nil, repeats: true)
    }
}


extension AppDelegate: NSWindowDelegate {
    func windowWillClose(notification: NSNotification) {
        // Quit the app if the main window is closed
        NSApplication.sharedApplication().terminate(window)
    }
}
