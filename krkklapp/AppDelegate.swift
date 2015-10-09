
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
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        
        view = KrkklView(frame: CGRectZero, isPreview: false)
        view!.autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
        view!.frame = window.contentView!.bounds
        window.contentView!.addSubview(view!)
        
        view!.startAnimation()
        NSTimer.scheduledTimerWithTimeInterval(1/view!.scene.fps, target: view!, selector: "animateOneFrame", userInfo: nil, repeats: true)
    }
    
    @IBAction func showPreferences(sender: NSObject!)
    {
        NSApp.beginSheet(view!.configureSheet()!, modalForWindow: window, modalDelegate: self, didEndSelector: "endSheet:", contextInfo: nil)
    }
    
    @objc private func endSheet(sheet: NSWindow)
    {
        sheet.close()
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
        if view != nil
        {
            view!.scene.setup(view!.preview, width: view!.width(), height: view!.height())
        }
    }
}
