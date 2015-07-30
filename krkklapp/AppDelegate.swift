
import Cocoa
import ScreenSaver

@NSApplicationMain
class AppDelegate: NSObject
{
    @IBOutlet var window: NSWindow!
    
    var view: KrkklView?
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension AppDelegate: NSApplicationDelegate
{
    func applicationDidFinishLaunching(notification: NSNotification)
    {
        view = KrkklView(frame: CGRectZero, isPreview: false)
        view!.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable
        view!.frame = window.contentView.bounds
        window.contentView.addSubview(view!)
        
        view!.startAnimation()
        NSTimer.scheduledTimerWithTimeInterval(view!.animationTimeInterval(), target: view!, selector: "animateOneFrame", userInfo: nil, repeats: true)
    }
}

extension AppDelegate: NSWindowDelegate
{
    func windowWillClose(notification: NSNotification)
    {
        NSApplication.sharedApplication().terminate(window)
    }
    
    func windowDidResize(notification: NSNotification)
    {
        view?.scene.setup()
    }
}
