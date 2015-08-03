import ScreenSaver

class Defaults
{
    var userDefaults: NSUserDefaults
    let version = "1.0.2"
    let defaultValues:[[String: AnyObject]] = [
        ["key": "rows",          "label": "number of cube rows",                 "values": [20, 100],   "range":  [10,   100], "step": 1   ],
        ["key": "cube_amount",   "label": "cube amount",                         "values": [2,    4],   "range":  [1,     10], "step": 1   ],
        ["key": "speed",         "label": "cubes per frame\nframes per second",  "values": [1,   60],   "range":  [1,     60], "step": 1   ],
        ["key": "fade",          "label": "fade duration in frames",             "value" : 180,         "range":  [10,   240], "step": 1   ],
        ["key": "contrasts",     "label": "left side\nright side cube shadow",   "values": [0.3, 0.6],  "range":  [0,      1], "step": 0.05],
        ["key": "color_fade",    "label": "color change speed",                  "values": [1,   50],   "range":  [1,    100], "step": 1   ],
        ["key": "keep_up",       "label": "keep direction up",                   "values": [0.2,0.9],   "range":  [0.0, 0.99], "step": 0.01],
        ["key": "keep_left",     "label": "keep direction left",                 "values": [0.2,0.9],   "range":  [0.0, 0.99], "step": 0.01],
        ["key": "keep_right",    "label": "keep direction right",                "values": [0.2,0.9],   "range":  [0.0, 0.99], "step": 0.01],
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