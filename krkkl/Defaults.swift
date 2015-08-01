import ScreenSaver

class Defaults
{
    var defaults: NSUserDefaults
    
    init()
    {
        let identifier = NSBundle(forClass: Defaults.self).bundleIdentifier
        defaults = ScreenSaverDefaults.defaultsForModuleWithName(identifier) as! NSUserDefaults
    }

    var canvasColor: NSColor
    {
        set(newColor)
        {
            setColor(newColor, key: "CanvasColor")
        }
        get
        {
            return getColor("CanvasColor") ?? NSColor.blackColor()
        }
    }

    var circleColor: NSColor
    {
        set(newColor)
        {
            setColor(newColor, key: "CircleColor")
        }
        get
        {
            return getColor("CircleColor") ?? NSColor(red: 0.5, green: 0.1, blue: 0.2, alpha: 1.0)
        }
    }

    func setColor(color: NSColor, key: String)
    {
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(color), forKey: key)
        defaults.synchronize()
    }

    func getColor(key: String) -> NSColor?
    {
        if let canvasColorData = defaults.objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(canvasColorData) as? NSColor
        }
        return nil;
    }

}