import ScreenSaver

let defaultValues:[[String: AnyObject]] = [
    [                        "title": "",                        "text": "values are choosen randomly between top and bottom sliders"],
    ["key": "rows",          "title": "number of cube rows",     "values": [20,  60],   "range":  [10,   200], "step": 1   ],
    ["key": "cube_amount",   "title": "cube amount",             "values": [3,    5],   "range":  [1,     10], "step": 0.2 ],
    ["key": "cpf",           "title": "cubes per frame",         "values": [1,    1],   "range":  [1,    200], "step": 1   ],
    [                        "title": "",                        "text": "how the next direction is choosen"],
    ["key": "reset",         "title": "border behaviour",        "values": [0, 1, 2],        "choices":[0, 1, 2],       "labels":["reset position", "reflect", "torus wrap"] ],
    ["key": "dir_inc",       "title": "direction increment",     "values": [1, 2, 3, 4, 5],  "choices":[1, 2, 3, 4, 5], "labels":["+1", "+2", "random", "-2", "-1"] ],
    [                        "title": "direction probability",   "text": "used when direction increment is random"],
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

let defaultColors:[String] = [
    "#6c0000#b50000#ff0000#ff9227#b50000",
    "#003a00#005e00#009700#00cd27#005e00",
    "#00002f#00006e#0000ff#595bff#00006e",
    "#323232#646464#b3b3b3#ffffff#515151",
    "#6fa1ce#060f3d#2b4376#6a9ac0#bae2f6#eee5fa",
    "#3b3d3b#c48655#e8d193#c48655#3b3d3b#8f8494#c8c9d1#8f8494#3b3d3b",
    "#257b4b#31a364#2f915a#1c653c#195232#ac8b32#e6ba43#cca640#8d7127#725c22#6b2472#8e3098#7d2c86#6b2472#46174b",
    "#ffe868#f7da35#bb9d00#937a00#785dc1#583aac#2c1583#1e0e67",
    "#b51700#fe2500#ff9225#ffff00#00cc27#009700#005e00#000f6e#0432ff#585aff",
]

var defaultPresets:[[String: AnyObject]] = [[
    "values": Defaults.infoValues(),
    "colors": defaultColors
    ]]

let defaultPresetsData = "WwogIHsKICAgICJjb2xvcnMiIDogWwogICAgICAiIzZjMDAwMCNiNTAwMDAjZmYwMDAwI2ZmOTIyNyNiNTAwMDAiLAogICAgICAiIzAwM2EwMCMwMDVlMDAjMDA5NzAwIzAwY2QyNyMwMDVlMDAiLAogICAgICAiIzAwMDAyZiMwMDAwNmUjMDAwMGZmIzU5NWJmZiMwMDAwNmUiLAogICAgICAiIzMyMzIzMiM2NDY0NjQjYjNiM2IzI2ZmZmZmZiM1MTUxNTEiCiAgICBdLAogICAgInZhbHVlcyIgOiB7CiAgICAgICJmcHMiIDogNjAsCiAgICAgICJjb2xvcl9yaWdodCIgOiBbCiAgICAgICAgMC43MDAwMDAwMDAwMDAwMDAxLAogICAgICAgIDEKICAgICAgXSwKICAgICAgImRpcl9pbmMiIDogWwogICAgICAgIDEsCiAgICAgICAgMywKICAgICAgICA1CiAgICAgIF0sCiAgICAgICJrZWVwX3JpZ2h0IiA6IFsKICAgICAgICAwLjMsCiAgICAgICAgMC42NAogICAgICBdLAogICAgICAiY3BmIiA6IFsKICAgICAgICAxLAogICAgICAgIDEKICAgICAgXSwKICAgICAgInByb2JfbGVmdCIgOiBbCiAgICAgICAgMCwKICAgICAgICAwLjEzCiAgICAgIF0sCiAgICAgICJjb2xvcl9mYWRlIiA6IFsKICAgICAgICAxMCwKICAgICAgICA0MAogICAgICBdLAogICAgICAiY3ViZV9hbW91bnQiIDogWwogICAgICAgIDMsCiAgICAgICAgNQogICAgICBdLAogICAgICAicHJvYl91cCIgOiBbCiAgICAgICAgMCwKICAgICAgICAwLjEKICAgICAgXSwKICAgICAgImtlZXBfdXAiIDogWwogICAgICAgIDAuNCwKICAgICAgICAwLjQ4CiAgICAgIF0sCiAgICAgICJjb2xvcl9sZWZ0IiA6IFsKICAgICAgICAwLjc1LAogICAgICAgIDEKICAgICAgXSwKICAgICAgInJvd3MiIDogWwogICAgICAgIDE4LAogICAgICAgIDgwCiAgICAgIF0sCiAgICAgICJjb2xvcl90b3AiIDogWwogICAgICAgIDAuODUwMDAwMDAwMDAwMDAwMSwKICAgICAgICAxCiAgICAgIF0sCiAgICAgICJwcm9iX3JpZ2h0IiA6IFsKICAgICAgICAwLAogICAgICAgIDAuMTgKICAgICAgXSwKICAgICAgImtlZXBfbGVmdCIgOiBbCiAgICAgICAgMC4zNSwKICAgICAgICAwLjU3MDAwMDAwMDAwMDAwMDEKICAgICAgXSwKICAgICAgImZhZGUiIDogMTAwLAogICAgICAicmVzZXQiIDogWwogICAgICAgIDAsCiAgICAgICAgMSwKICAgICAgICAyCiAgICAgIF0KICAgIH0KICB9LAogIHsKICAgICJjb2xvcnMiIDogWwogICAgICAiIzZmYTFjZSMwNjBmM2QjMmI0Mzc2IzZhOWFjMCNiYWUyZjYjZWVlNWZhIiwKICAgICAgIiMzYjNkM2IjYzQ4NjU1I2U4ZDE5MyNjNDg2NTUjM2IzZDNiIzhmODQ5NCNjOGM5ZDEjOGY4NDk0IzNiM2QzYiIKICAgIF0sCiAgICAidmFsdWVzIiA6IHsKICAgICAgImZwcyIgOiA2MCwKICAgICAgImNvbG9yX3JpZ2h0IiA6IFsKICAgICAgICAwLjgsCiAgICAgICAgMQogICAgICBdLAogICAgICAiZGlyX2luYyIgOiBbCiAgICAgICAgMSwKICAgICAgICAyLAogICAgICAgIDMsCiAgICAgICAgNCwKICAgICAgICA1CiAgICAgIF0sCiAgICAgICJrZWVwX3JpZ2h0IiA6IFsKICAgICAgICAwLjksCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiY3BmIiA6IFsKICAgICAgICAxLAogICAgICAgIDIwCiAgICAgIF0sCiAgICAgICJwcm9iX2xlZnQiIDogWwogICAgICAgIDAsCiAgICAgICAgMC4yNQogICAgICBdLAogICAgICAiY29sb3JfZmFkZSIgOiBbCiAgICAgICAgMSwKICAgICAgICAxMAogICAgICBdLAogICAgICAiY3ViZV9hbW91bnQiIDogWwogICAgICAgIDQsCiAgICAgICAgNgogICAgICBdLAogICAgICAicHJvYl91cCIgOiBbCiAgICAgICAgMC45MiwKICAgICAgICAwLjk5CiAgICAgIF0sCiAgICAgICJrZWVwX3VwIiA6IFsKICAgICAgICAwLjksCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiY29sb3JfbGVmdCIgOiBbCiAgICAgICAgMC41NSwKICAgICAgICAxCiAgICAgIF0sCiAgICAgICJyb3dzIiA6IFsKICAgICAgICA1MCwKICAgICAgICAxNjAKICAgICAgXSwKICAgICAgImNvbG9yX3RvcCIgOiBbCiAgICAgICAgMC4yNSwKICAgICAgICAwLjYwMDAwMDAwMDAwMDAwMDEKICAgICAgXSwKICAgICAgInByb2JfcmlnaHQiIDogWwogICAgICAgIDAsCiAgICAgICAgMC41MwogICAgICBdLAogICAgICAia2VlcF9sZWZ0IiA6IFsKICAgICAgICAwLjksCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiZmFkZSIgOiAxMDAsCiAgICAgICJyZXNldCIgOiBbCiAgICAgICAgMQogICAgICBdCiAgICB9CiAgfSwKICB7CiAgICAiY29sb3JzIiA6IFsKICAgICAgIiMyNTdiNGIjMzFhMzY0IzJmOTE1YSMxYzY1M2MjMTk1MjMyI2FjOGIzMiNlNmJhNDMjY2NhNjQwIzhkNzEyNyM3MjVjMjIjNmIyNDcyIzhlMzA5OCM3ZDJjODYjNmIyNDcyIzQ2MTc0YiIsCiAgICAgICIjZmZlODY4I2Y3ZGEzNSNiYjlkMDAjOTM3YTAwIzc4NWRjMSM1ODNhYWMjMmMxNTgzIzFlMGU2NyIsCiAgICAgICIjYjUxNzAwI2ZlMjUwMCNmZjkyMjUjZmZmZjAwIzAwY2MyNyMwMDk3MDAjMDA1ZTAwIzAwMGY2ZSMwNDMyZmYjNTg1YWZmIgogICAgXSwKICAgICJ2YWx1ZXMiIDogewogICAgICAiZnBzIiA6IDYwLAogICAgICAiY29sb3JfcmlnaHQiIDogWwogICAgICAgIDAuODUwMDAwMDAwMDAwMDAwMSwKICAgICAgICAxCiAgICAgIF0sCiAgICAgICJkaXJfaW5jIiA6IFsKICAgICAgICAxLAogICAgICAgIDIsCiAgICAgICAgMywKICAgICAgICA0LAogICAgICAgIDUKICAgICAgXSwKICAgICAgImtlZXBfcmlnaHQiIDogWwogICAgICAgIDAsCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiY3BmIiA6IFsKICAgICAgICAxLAogICAgICAgIDEKICAgICAgXSwKICAgICAgInByb2JfbGVmdCIgOiBbCiAgICAgICAgMCwKICAgICAgICAwLjk5CiAgICAgIF0sCiAgICAgICJjb2xvcl9mYWRlIiA6IFsKICAgICAgICAxLAogICAgICAgIDIwCiAgICAgIF0sCiAgICAgICJjdWJlX2Ftb3VudCIgOiBbCiAgICAgICAgMywKICAgICAgICA1CiAgICAgIF0sCiAgICAgICJwcm9iX3VwIiA6IFsKICAgICAgICAwLAogICAgICAgIDAuOTkKICAgICAgXSwKICAgICAgImtlZXBfdXAiIDogWwogICAgICAgIDAsCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiY29sb3JfbGVmdCIgOiBbCiAgICAgICAgMC4zNSwKICAgICAgICAwLjgKICAgICAgXSwKICAgICAgInJvd3MiIDogWwogICAgICAgIDIwLAogICAgICAgIDEwMAogICAgICBdLAogICAgICAiY29sb3JfdG9wIiA6IFsKICAgICAgICAwLjI1LAogICAgICAgIDAuNjUKICAgICAgXSwKICAgICAgInByb2JfcmlnaHQiIDogWwogICAgICAgIDAsCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAia2VlcF9sZWZ0IiA6IFsKICAgICAgICAwLAogICAgICAgIDAuOTkKICAgICAgXSwKICAgICAgImZhZGUiIDogMTAwLAogICAgICAicmVzZXQiIDogWwogICAgICAgIDAsCiAgICAgICAgMgogICAgICBdCiAgICB9CiAgfQpd"

class Defaults
{
    static let defaultInfo = defaultValues
    var userDefaults: NSUserDefaults
    var presetIndex = 0
    
    init()
    {
        let identifier = NSBundle(forClass: Defaults.self).bundleIdentifier
        userDefaults = ScreenSaverDefaults(forModuleWithName:identifier!)!

        if getObjectForKey("presets") != nil
        {
            presets = getObjectForKey("presets") as! [[String: AnyObject]]
        }
        else
        {
            restoreDefaults()
        }
        
        let version = defaultValues.description
        setObjectForKey(version, key:"version")
    }
    
    func restoreDefaults()
    {
        let data = NSData(base64EncodedString:defaultPresetsData, options:NSDataBase64DecodingOptions(rawValue: 0))
        presets = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! [[String: AnyObject]]
//        presetIndex = 0
//        presets = defaultPresets
    }
    
    var presets: [[String: AnyObject]]
    {
        set(newValues)
        {
            setObjectForKey(newValues, key:"presets")
        }
        get
        {
            return getObjectForKey("presets") as! [[String: AnyObject]]
        }
    }
    
    func defaultPreset() -> [String: AnyObject]
    {
        return defaultPresets[0]
    }
    
    var values: [String: AnyObject]
    {
        set(newValues)
        {
            presets[presetIndex]["values"] = newValues
        }
        get
        {
            return presets[presetIndex]["values"] as! [String: AnyObject]
        }
    }
    
    var colorLists: [[NSColor]]
    {
        set(newColorLists)
        {
            presets[presetIndex]["colors"] = Defaults.colorListsToStringList(newColorLists)
        }
        get
        {
            return Defaults.stringListToColorLists(presets[presetIndex]["colors"] as! [String])
        }
    }
    
    static func colorListsToStringList(colorLists: [[NSColor]]) -> [String]
    {
        var stringList:[String] = []
        for colors in colorLists
        {
            var colorString = ""
            for color in colors
            {
                colorString += color.hex()
            }
            stringList.append(colorString)
        }
        return stringList
    }

    static func stringListToColorLists(stringLists: [String]) -> [[NSColor]]
    {
        var lists:[[NSColor]] = []
        for list in stringLists
        {
            let hexList = list.characters.split {$0 == "#"}.map { String($0) }
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
            lists.append(colorList)
        }
        return lists
    }
    
    static func infoValues() -> [String: AnyObject]
    {
        var values = [String: AnyObject]()
        for valueRow in defaultInfo
        {
            if valueRow["key"] != nil
            {
                values[valueRow["key"] as! String] = (valueRow["value"] != nil ? valueRow["value"] : valueRow["values"])
            }
        }
        return values
    }
    
    static func presetValueForKey(preset:[String: AnyObject], key:String) -> AnyObject?
    {
        let vals = preset["values"]!
        return vals[key]
    }
    
    func valueForKey(key:String) -> AnyObject?
    {
        return self.values[key]
    }
        
    func setObjectForKey(object: AnyObject, key: String)
    {
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(object), forKey: key)
        userDefaults.synchronize()
    }

    func getObjectForKey(key: String) -> AnyObject?
    {
        if let dictData = userDefaults.objectForKey(key) as? NSData
        {
            return NSKeyedUnarchiver.unarchiveObjectWithData(dictData)
        }
        return nil;
    }    
}
