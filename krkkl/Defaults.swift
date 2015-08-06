import ScreenSaver

class Defaults
{
    var userDefaults: NSUserDefaults
    
    /*
      000   000   0000000   000      000   000  00000000   0000000
      000   000  000   000  000      000   000  000       000     
       000 000   000000000  000      000   000  0000000   0000000 
         000     000   000  000      000   000  000            000
          0      000   000  0000000   0000000   00000000  0000000 
    */
    
    let defaultValues:[[String: AnyObject]] = [
        [                        "title": "",                        "text": "values are choosen randomly between top and bottom sliders"],
        ["key": "rows",          "title": "number of cube rows",     "values": [20,  60],   "range":  [10,   100], "step": 1   ],
        ["key": "cube_amount",   "title": "cube amount",             "values": [3,    5],   "range":  [1,     10], "step": 0.2 ],
        ["key": "cpf",           "title": "cubes per frame",         "values": [1,    1],   "range":  [1,    200], "step": 1   ],
        [                        "title": "",                        "text": "how the next direction is choosen"],
        ["key": "dir_incr",      "title": "direction increment",     "value" :  3,          "range":  [1,      5], "step": 1   ],
        [                        "title": "direction probability",   "text": "used when direction increment is 3"],
        ["key": "prob_up",       "label": "up",                      "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        ["key": "prob_left",     "label": "left",                    "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        ["key": "prob_right",    "label": "right",                   "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        [                        "title": "keep direction",          "text": "higher values yield longer straight lines"],
        ["key": "keep_up",       "label": "up",                      "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        ["key": "keep_left",     "label": "left",                    "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        ["key": "keep_right",    "label": "right",                   "values": [0.0,0.99],  "range":  [0.0, 0.99], "step": 0.01],
        [                        "title": "",                        "text": "lower values yield smoother color fades"],
        ["key": "color_fade",    "title": "color change speed",      "values": [1,    20],  "range":  [1,    100], "step": 1   ],
        [                        "title": "brightness",                        "text": "lower values yield darker colors"],
        ["key": "color_top",     "label": "top side",                "values": [0.4, 1.0],  "range":  [0,      1], "step": 0.05],
        ["key": "color_left",    "label": "left side",               "values": [0.0, 1.0],  "range":  [0,      1], "step": 0.05],
        ["key": "color_right",   "label": "right side",              "values": [0.0, 1.0],  "range":  [0,      1], "step": 0.05],
        [                        "title": "",                        "text": ""],
        ["key": "fps",           "title": "frames per second",       "value" :  60,         "range":  [1,     60], "step": 1   ],
        ["key": "fade",          "title": "fade duration in frames", "value" : 100,         "range":  [10,   240], "step": 1   ],
    ]
    
    /*
       0000000   0000000   000       0000000   00000000    0000000
      000       000   000  000      000   000  000   000  000     
      000       000   000  000      000   000  0000000    0000000 
      000       000   000  000      000   000  000   000       000
       0000000   0000000   0000000   0000000   000   000  0000000 
    */
    
    let defaultColors = "#6c0000#b50000#ff0000#ff9227#b50000,#003a00#005e00#009700#00cd27#005e00,#00002f#00006e#0000ff#595bff#00006e,#323232#646464#b3b3b3#ffffff#515151,#b51700#fe2500#ff9225#ffff00#00cc27#009700#005e00#000f6e#0432ff#585aff,#3a3a3a#1305f1#3a3a3a#5a5aff#383838#e22ca0#383838#dc1e00#383838#d132d1,#000000#d90000#ff6b00#ffba00#ffff00#ffba00#ff6b00#d90000#6e0000,#000000#d90000#000000#ffffff#000000#f23e04#000000#515151,#3b3d3b#c48655#e8d193#c48655#3b3d3b#8f8494#c8c9d1#8f8494#3b3d3b,#f1d959#fe555e#7b526f#34497b#1f2348#04040e,#6fa1ce#060f3d#2b4376#6a9ac0#bae2f6#eee5fa,#ffe868#f7da35#bb9d00#937a00#785dc1#583aac#2c1583#1e0e67,#257b4b#31a364#2f915a#1c653c#195232#ac8b32#e6ba43#cca640#8d7127#725c22#6b2472#8e3098#7d2c86#6b2472#46174b"

    init()
    {
        let version = defaultValues.description
        let identifier = NSBundle(forClass: Defaults.self).bundleIdentifier
        userDefaults = ScreenSaverDefaults.defaultsForModuleWithName(identifier) as! NSUserDefaults
        
        if getObjectForKey("version") as? String != version
        {
            values = defaultValues
            colorLists = defaultColorLists()
        }
        
        if colorLists.count == 0
        {
            colorLists = defaultColorLists()
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
    
    var colorLists: [[NSColor]]
    {
        set(newColorLists)
        {
            setObjectForKey(newColorLists, key:"colorLists")
        }
        get
        {
            return (getObjectForKey("colorLists") ?? defaultColorLists()) as! [[NSColor]]
        }
    }
    
    func defaultColorLists() -> [[NSColor]]
    {
        var colorLists:[[NSColor]] = []
        let strList = split(defaultColors) {$0 == ","}
        for list in strList
        {
            let hexList = split(list) {$0 == "#"}
            var colorList:[NSColor] = []
            for hexColor in hexList
            {
                var r:UInt32 = 0
                var g:UInt32 = 0
                var b:UInt32 = 0
                NSScanner(string:hexColor.substring(0,2)).scanHexInt(&r)
                NSScanner(string:hexColor.substring(2,2)).scanHexInt(&g)
                NSScanner(string:hexColor.substring(4,2)).scanHexInt(&b)
                colorList.append(colorRGB([Float(r)/255.0,Float(g)/255.0,Float(b)/255.0]))
            }
            colorLists.append(colorList)
        }
        return colorLists
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
