import ScreenSaver

class Defaults
{
    var defaults: NSUserDefaults
    var defaultValues:[[String: AnyObject]] = [
        ["key": "rows",  "label": "number of cube rows",  "value": [20, 100], "range": [5, 500],     "step": 1   ],
        ["key": "keepx", "label": "keep direction up",    "value": [0.2,0.9], "range": [0.01, 0.99], "step": 0.01],
        ["key": "keepy", "label": "keep direction left",  "value": [0.2,0.9], "range": [0.01, 0.99], "step": 0.01],
        ["key": "keepz", "label": "keep direction right", "value": [0.2,0.9], "range": [0.01, 0.99], "step": 0.01],
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