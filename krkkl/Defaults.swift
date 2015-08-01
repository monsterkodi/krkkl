import ScreenSaver

class Defaults
{
    var defaults: NSUserDefaults
    var defaultValues:[[String: AnyObject]] = [
        ["label": "min rows", "value": 20],
        ["label": "max rows", "value": 100]
    ]
    
    init()
    {
        let identifier = NSBundle(forClass: Defaults.self).bundleIdentifier
        defaults = ScreenSaverDefaults.defaultsForModuleWithName(identifier) as! NSUserDefaults
    }
    
    var values: [[String: AnyObject]]
    {
        set(newValues)
        {
            setObjectForKey(newValues, key:"values")
        }
        get
        {
            return (getObjectForKey("values") ?? defaultValues) as! [[String: AnyObject]]
        }
    }
    
    func setObjectForKey(object: AnyObject, key: String)
    {
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(object), forKey: key)
        defaults.synchronize()
    }

    func getObjectForKey(key: String) -> AnyObject?
    {
        if let dictData = defaults.objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(dictData)
        }
        return nil;
    }
}