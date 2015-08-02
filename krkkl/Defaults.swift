import ScreenSaver

class Defaults
{
    var userDefaults: NSUserDefaults
    let version = "1.0.0"
    let defaultValues:[[String: AnyObject]] = [
        ["key": "rows",       "label": "number of cube rows",  "value": [20, 100], "range": [10,   100], "step": 1   ],
        ["key": "speed",      "label": "cubes per frame\nframes per second",  "value": [60, 60], "range": [1,   60], "step": 1   ],
        ["key": "cube_amount","label": "min\nmax cube amount", "value": [2, 4], "range": [1, 10], "step": 1   ],
        ["key": "keep_up",    "label": "keep direction up",    "value": [0.2,0.9], "range": [0.0, 0.99], "step": 0.01],
        ["key": "keep_left",  "label": "keep direction left",  "value": [0.2,0.9], "range": [0.0, 0.99], "step": 0.01],
        ["key": "keep_right", "label": "keep direction right", "value": [0.2,0.9], "range": [0.0, 0.99], "step": 0.01],
    ]
    
    init()
    {
        let identifier = NSBundle(forClass: Defaults.self).bundleIdentifier
        userDefaults = ScreenSaverDefaults.defaultsForModuleWithName(identifier) as! NSUserDefaults
        
        if getObjectForKey("version") as? String != version
        {
            values = defaultValues
        }
        setObjectForKey(version, key:"version")
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
    
    func valueForKey(key:String) -> AnyObject?
    {
        return values[rowForKey(key)]
    }
    
    func rowForKey(key:String) -> Int
    {
        for index in 0...values.count
        {
            if (values[index]["key"] as! String) == key
            {
                return index
            }
        }
        return -1
    }
    
    func setObjectForKey(object: AnyObject, key: String)
    {
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(object), forKey: key)
        userDefaults.synchronize()
    }

    func getObjectForKey(key: String) -> AnyObject?
    {
        if let dictData = userDefaults.objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(dictData)
        }
        return nil;
    }    
}