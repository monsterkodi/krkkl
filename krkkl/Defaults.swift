import ScreenSaver

class Defaults
{
    var userDefaults: NSUserDefaults
    
    let defaultValues:[[String: AnyObject]] = [
        [                        "title": "",                        "text": "values are choosen randomly between top and bottom sliders"],
        ["key": "rows",          "title": "number of cube rows",     "values": [20,  60],   "range":  [10,   100], "step": 1   ],
        ["key": "cube_amount",   "title": "cube amount",             "values": [3,    5],   "range":  [1,     10], "step": 0.2 ],
        ["key": "cpf",           "title": "cubes per frame",         "values": [1,    1],   "range":  [1,    200], "step": 1   ],
        [                        "title": "",                        "text": "how the next direction is choosen"],
        ["key": "dir_incr",      "title": "direction increment",     "value" :  3,          "range":  [1,      5], "step": 1   ],
        [                        "title": "direction probability",   "text": "used when direction increment is 3"],
        ["key": "prob_up",       "label": "up",          "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        ["key": "prob_left",     "label": "left",        "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        ["key": "prob_right",    "label": "right",       "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        [                        "title": "keep direction",          "text": "higher values yield longer straight lines"],
        ["key": "keep_up",       "label": "up",       "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        ["key": "keep_left",     "label": "left",     "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        ["key": "keep_right",    "label": "right",    "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        [                        "title": "",                        "text": "lower values yield smoother color fades"],
        ["key": "color_fade",    "title": "color change speed",      "values": [1,    20],  "range":  [1,    100], "step": 1   ],
        [                        "title": "brightness",                        "text": "lower values yield darker colors"],
        ["key": "color_top",     "label": "top side",     "values": [0.4, 1.0],  "range":  [0,      1], "step": 0.05],
        ["key": "color_left",    "label": "left side",    "values": [0.0, 1.0],  "range":  [0,      1], "step": 0.05],
        ["key": "color_right",   "label": "right side",   "values": [0.0, 1.0],  "range":  [0,      1], "step": 0.05],
        [                        "title": "",                        "text": ""],
        ["key": "fps",           "title": "frames per second",       "value" :  60,         "range":  [1,     60], "step": 1   ],
        ["key": "fade",          "title": "fade duration in frames", "value" : 100,         "range":  [10,   240], "step": 1   ],
    ]
    
    init()
    {
        let version = defaultValues.description
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
            if (values[index]["key"] as? String) == key
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
