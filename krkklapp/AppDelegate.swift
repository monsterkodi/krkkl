
import Cocoa
import ScreenSaver

@NSApplicationMain
class AppDelegate: NSObject
{
    @IBOutlet var window: NSWindow!
    
    var view: KrkklView?
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AppDelegate: NSApplicationDelegate
{
    func applicationDidFinishLaunching()
    {
        UserDefaults.standard.set(false, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        
        view = KrkklView(frame: CGRect.zero, isPreview: false)
        view!.autoresizingMask = [NSAutoresizingMaskOptions.viewWidthSizable, NSAutoresizingMaskOptions.viewHeightSizable]
        view!.frame = window.contentView!.bounds
        window.contentView!.addSubview(view!)
        
        view!.startAnimation()
        Timer.scheduledTimer(timeInterval: 1/view!.scene.fps, target: view!, selector: #selector(ScreenSaverView.animateOneFrame), userInfo: nil, repeats: true)
    }
    
    @IBAction func showPreferences(sender: NSObject!)
    {
        NSApp.beginSheet(view!.configureSheet()!, modalFor: window, modalDelegate: self, didEnd: #selector(NSApplication.endSheet(_:)), contextInfo: nil)
    }
    
    @objc private func endSheet(sheet: NSWindow)
    {
        sheet.close()
    }
}

extension AppDelegate: NSWindowDelegate
{
    func windowWillClose()
    {
        NSApplication.shared().terminate(window)
    }
    
    func windowDidResize()
    {
        if view != nil
        {
            view!.restart()
        }
    }
}
