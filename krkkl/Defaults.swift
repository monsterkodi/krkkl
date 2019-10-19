import ScreenSaver

let defaultValues:[[String: AnyObject]] = [
    [                                   "title": "" as AnyObject,                        "text": "values are choosen randomly between top and bottom sliders" as AnyObject],
    ["key": "rows" as AnyObject,        "title": "number of cube rows" as AnyObject,     "values": [20,  60] as AnyObject,   "range":  [10,   200] as AnyObject, "step": 1    as AnyObject],
    ["key": "cube_amount" as AnyObject, "title": "cube amount" as AnyObject,             "values": [3,    5] as AnyObject,   "range":  [1,     10] as AnyObject, "step": 0.2  as AnyObject],
    ["key": "cpf" as AnyObject,         "title": "cubes per frame" as AnyObject,         "values": [1,    1] as AnyObject,   "range":  [1,    200] as AnyObject, "step": 1    as AnyObject],
    [                                   "title": "" as AnyObject,                        "text": "how the next direction is choosen" as AnyObject],
    ["key": "reset" as AnyObject,       "title": "border behaviour" as AnyObject,        "values": [0, 1, 2] as AnyObject,        "choices":[0, 1, 2] as AnyObject,       "labels":["reset position", "reflect", "torus wrap"] as AnyObject ],
    ["key": "dir_inc" as AnyObject,     "title": "direction increment" as AnyObject,     "values": [1, 2, 3, 4, 5] as AnyObject,  "choices":[1, 2, 3, 4, 5] as AnyObject, "labels":["+1", "+2", "random", "-2", "-1"]          as AnyObject ],
    [                                   "title": "direction probability" as AnyObject,   "text": "used when direction increment is random" as AnyObject],
    ["key": "prob_up" as AnyObject,     "label": "up" as AnyObject,                      "values": [0.0,0.99] as AnyObject,  "range":  [0.0, 0.99] as AnyObject, "step": 0.01 as AnyObject],
    ["key": "prob_left" as AnyObject,   "label": "left" as AnyObject,                    "values": [0.0,0.99] as AnyObject,  "range":  [0.0, 0.99] as AnyObject, "step": 0.01 as AnyObject],
    ["key": "prob_right" as AnyObject,  "label": "right" as AnyObject,                   "values": [0.0,0.99] as AnyObject,  "range":  [0.0, 0.99] as AnyObject, "step": 0.01 as AnyObject],
    [                                   "title": "keep direction" as AnyObject,          "text": "higher values yield longer straight lines" as AnyObject],
    ["key": "keep_up" as AnyObject,     "label": "up" as AnyObject,                      "values": [0.0,0.99] as AnyObject,  "range":  [0.0, 0.99] as AnyObject, "step": 0.01 as AnyObject],
    ["key": "keep_left" as AnyObject,   "label": "left" as AnyObject,                    "values": [0.0,0.99] as AnyObject,  "range":  [0.0, 0.99] as AnyObject, "step": 0.01 as AnyObject],
    ["key": "keep_right" as AnyObject,  "label": "right" as AnyObject,                   "values": [0.0,0.99] as AnyObject,  "range":  [0.0, 0.99] as AnyObject, "step": 0.01 as AnyObject],
    [                                   "title": "" as AnyObject,                        "text": "lower values yield smoother color fades" as AnyObject],
    ["key": "color_fade" as AnyObject,  "title": "color change speed" as AnyObject,      "values": [1,    20] as AnyObject,  "range":  [1,    100] as AnyObject, "step": 1    as AnyObject],
    [                                   "title": "brightness" as AnyObject,              "text": "lower values yield darker colors" as AnyObject],
    ["key": "color_top" as AnyObject,   "label": "top side" as AnyObject,                "values": [0.4, 1.0] as AnyObject,  "range":  [0,      1] as AnyObject, "step": 0.05 as AnyObject],
    ["key": "color_left" as AnyObject,  "label": "left side" as AnyObject,               "values": [0.0, 1.0] as AnyObject,  "range":  [0,      1] as AnyObject, "step": 0.05 as AnyObject],
    ["key": "color_right" as AnyObject, "label": "right side" as AnyObject,              "values": [0.0, 1.0] as AnyObject,  "range":  [0,      1] as AnyObject, "step": 0.05 as AnyObject],
    [                                   "title": "" as AnyObject,                        "text": "" as AnyObject],
    ["key": "fps" as AnyObject,         "title": "frames per second" as AnyObject,       "value" :  60 as AnyObject,         "range":  [1,     60] as AnyObject, "step": 1    as AnyObject],
    ["key": "fade" as AnyObject,        "title": "fade duration in frames" as AnyObject, "value" : 100 as AnyObject,         "range":  [10,   240] as AnyObject, "step": 1    as AnyObject],
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
    "values": Defaults.infoValues() as AnyObject,
    "colors": defaultColors as AnyObject
    ]]

let defaultPresetsData = "WwogIHsKICAgICJjb2xvcnMiIDogWwogICAgICAiIzZjMDAwMCNiNTAwMDAjZmYwMDAwI2ZmOTIyNyNiNTAwMDAiLAogICAgICAiIzAwM2EwMCMwMDVlMDAjMDA5NzAwIzAwY2QyNyMwMDVlMDAiLAogICAgICAiIzAwMDAyZiMwMDAwNmUjMDAwMGZmIzU5NWJmZiMwMDAwNmUiLAogICAgICAiIzMyMzIzMiM2NDY0NjQjYjNiM2IzI2ZmZmZmZiM1MTUxNTEiCiAgICBdLAogICAgInZhbHVlcyIgOiB7CiAgICAgICJmcHMiIDogNjAsCiAgICAgICJjb2xvcl9yaWdodCIgOiBbCiAgICAgICAgMC43MDAwMDAwMDAwMDAwMDAxLAogICAgICAgIDEKICAgICAgXSwKICAgICAgImRpcl9pbmMiIDogWwogICAgICAgIDEsCiAgICAgICAgMywKICAgICAgICA1CiAgICAgIF0sCiAgICAgICJrZWVwX3JpZ2h0IiA6IFsKICAgICAgICAwLjMsCiAgICAgICAgMC42NAogICAgICBdLAogICAgICAiY3BmIiA6IFsKICAgICAgICAxLAogICAgICAgIDEKICAgICAgXSwKICAgICAgInByb2JfbGVmdCIgOiBbCiAgICAgICAgMCwKICAgICAgICAwLjEzCiAgICAgIF0sCiAgICAgICJjb2xvcl9mYWRlIiA6IFsKICAgICAgICAxMCwKICAgICAgICA0MAogICAgICBdLAogICAgICAiY3ViZV9hbW91bnQiIDogWwogICAgICAgIDMsCiAgICAgICAgNQogICAgICBdLAogICAgICAicHJvYl91cCIgOiBbCiAgICAgICAgMCwKICAgICAgICAwLjEKICAgICAgXSwKICAgICAgImtlZXBfdXAiIDogWwogICAgICAgIDAuNCwKICAgICAgICAwLjQ4CiAgICAgIF0sCiAgICAgICJjb2xvcl9sZWZ0IiA6IFsKICAgICAgICAwLjc1LAogICAgICAgIDEKICAgICAgXSwKICAgICAgInJvd3MiIDogWwogICAgICAgIDE4LAogICAgICAgIDgwCiAgICAgIF0sCiAgICAgICJjb2xvcl90b3AiIDogWwogICAgICAgIDAuODUwMDAwMDAwMDAwMDAwMSwKICAgICAgICAxCiAgICAgIF0sCiAgICAgICJwcm9iX3JpZ2h0IiA6IFsKICAgICAgICAwLAogICAgICAgIDAuMTgKICAgICAgXSwKICAgICAgImtlZXBfbGVmdCIgOiBbCiAgICAgICAgMC4zNSwKICAgICAgICAwLjU3MDAwMDAwMDAwMDAwMDEKICAgICAgXSwKICAgICAgImZhZGUiIDogMTAwLAogICAgICAicmVzZXQiIDogWwogICAgICAgIDAsCiAgICAgICAgMSwKICAgICAgICAyCiAgICAgIF0KICAgIH0KICB9LAogIHsKICAgICJjb2xvcnMiIDogWwogICAgICAiIzZmYTFjZSMwNjBmM2QjMmI0Mzc2IzZhOWFjMCNiYWUyZjYjZWVlNWZhIiwKICAgICAgIiMzYjNkM2IjYzQ4NjU1I2U4ZDE5MyNjNDg2NTUjM2IzZDNiIzhmODQ5NCNjOGM5ZDEjOGY4NDk0IzNiM2QzYiIKICAgIF0sCiAgICAidmFsdWVzIiA6IHsKICAgICAgImZwcyIgOiA2MCwKICAgICAgImNvbG9yX3JpZ2h0IiA6IFsKICAgICAgICAwLjgsCiAgICAgICAgMQogICAgICBdLAogICAgICAiZGlyX2luYyIgOiBbCiAgICAgICAgMSwKICAgICAgICAyLAogICAgICAgIDMsCiAgICAgICAgNCwKICAgICAgICA1CiAgICAgIF0sCiAgICAgICJrZWVwX3JpZ2h0IiA6IFsKICAgICAgICAwLjksCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiY3BmIiA6IFsKICAgICAgICAxLAogICAgICAgIDIwCiAgICAgIF0sCiAgICAgICJwcm9iX2xlZnQiIDogWwogICAgICAgIDAsCiAgICAgICAgMC4yNQogICAgICBdLAogICAgICAiY29sb3JfZmFkZSIgOiBbCiAgICAgICAgMSwKICAgICAgICAxMAogICAgICBdLAogICAgICAiY3ViZV9hbW91bnQiIDogWwogICAgICAgIDQsCiAgICAgICAgNgogICAgICBdLAogICAgICAicHJvYl91cCIgOiBbCiAgICAgICAgMC45MiwKICAgICAgICAwLjk5CiAgICAgIF0sCiAgICAgICJrZWVwX3VwIiA6IFsKICAgICAgICAwLjksCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiY29sb3JfbGVmdCIgOiBbCiAgICAgICAgMC41NSwKICAgICAgICAxCiAgICAgIF0sCiAgICAgICJyb3dzIiA6IFsKICAgICAgICA1MCwKICAgICAgICAxNjAKICAgICAgXSwKICAgICAgImNvbG9yX3RvcCIgOiBbCiAgICAgICAgMC4yNSwKICAgICAgICAwLjYwMDAwMDAwMDAwMDAwMDEKICAgICAgXSwKICAgICAgInByb2JfcmlnaHQiIDogWwogICAgICAgIDAsCiAgICAgICAgMC41MwogICAgICBdLAogICAgICAia2VlcF9sZWZ0IiA6IFsKICAgICAgICAwLjksCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiZmFkZSIgOiAxMDAsCiAgICAgICJyZXNldCIgOiBbCiAgICAgICAgMQogICAgICBdCiAgICB9CiAgfSwKICB7CiAgICAiY29sb3JzIiA6IFsKICAgICAgIiMyNTdiNGIjMzFhMzY0IzJmOTE1YSMxYzY1M2MjMTk1MjMyI2FjOGIzMiNlNmJhNDMjY2NhNjQwIzhkNzEyNyM3MjVjMjIjNmIyNDcyIzhlMzA5OCM3ZDJjODYjNmIyNDcyIzQ2MTc0YiIsCiAgICAgICIjZmZlODY4I2Y3ZGEzNSNiYjlkMDAjOTM3YTAwIzc4NWRjMSM1ODNhYWMjMmMxNTgzIzFlMGU2NyIsCiAgICAgICIjYjUxNzAwI2ZlMjUwMCNmZjkyMjUjZmZmZjAwIzAwY2MyNyMwMDk3MDAjMDA1ZTAwIzAwMGY2ZSMwNDMyZmYjNTg1YWZmIgogICAgXSwKICAgICJ2YWx1ZXMiIDogewogICAgICAiZnBzIiA6IDYwLAogICAgICAiY29sb3JfcmlnaHQiIDogWwogICAgICAgIDAuODUwMDAwMDAwMDAwMDAwMSwKICAgICAgICAxCiAgICAgIF0sCiAgICAgICJkaXJfaW5jIiA6IFsKICAgICAgICAxLAogICAgICAgIDIsCiAgICAgICAgMywKICAgICAgICA0LAogICAgICAgIDUKICAgICAgXSwKICAgICAgImtlZXBfcmlnaHQiIDogWwogICAgICAgIDAsCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiY3BmIiA6IFsKICAgICAgICAxLAogICAgICAgIDEKICAgICAgXSwKICAgICAgInByb2JfbGVmdCIgOiBbCiAgICAgICAgMCwKICAgICAgICAwLjk5CiAgICAgIF0sCiAgICAgICJjb2xvcl9mYWRlIiA6IFsKICAgICAgICAxLAogICAgICAgIDIwCiAgICAgIF0sCiAgICAgICJjdWJlX2Ftb3VudCIgOiBbCiAgICAgICAgMywKICAgICAgICA1CiAgICAgIF0sCiAgICAgICJwcm9iX3VwIiA6IFsKICAgICAgICAwLAogICAgICAgIDAuOTkKICAgICAgXSwKICAgICAgImtlZXBfdXAiIDogWwogICAgICAgIDAsCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAiY29sb3JfbGVmdCIgOiBbCiAgICAgICAgMC4zNSwKICAgICAgICAwLjgKICAgICAgXSwKICAgICAgInJvd3MiIDogWwogICAgICAgIDIwLAogICAgICAgIDEwMAogICAgICBdLAogICAgICAiY29sb3JfdG9wIiA6IFsKICAgICAgICAwLjI1LAogICAgICAgIDAuNjUKICAgICAgXSwKICAgICAgInByb2JfcmlnaHQiIDogWwogICAgICAgIDAsCiAgICAgICAgMC45OQogICAgICBdLAogICAgICAia2VlcF9sZWZ0IiA6IFsKICAgICAgICAwLAogICAgICAgIDAuOTkKICAgICAgXSwKICAgICAgImZhZGUiIDogMTAwLAogICAgICAicmVzZXQiIDogWwogICAgICAgIDAsCiAgICAgICAgMgogICAgICBdCiAgICB9CiAgfQpd"

class Defaults
{
    static let defaultInfo = defaultValues
    var userDefaults: UserDefaults
    var presetIndex = 0
    
    init()
    {
        let identifier = Bundle(for: Defaults.self).bundleIdentifier
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
        setObjectForKey(version as AnyObject, key:"version")
    }
    
    func restoreDefaults()
    {
        let data = Data(base64Encoded:defaultPresetsData, options:NSData.Base64DecodingOptions(rawValue: 0))
        presets = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! [[String: AnyObject]]
//        presetIndex = 0
//        presets = defaultPresets
    }
    
    var presets: [[String: AnyObject]]
    {
        set(newValues)
        {
            setObjectForKey(newValues as AnyObject, key:"presets")
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
            presets[presetIndex]["values"] = newValues as AnyObject
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
            presets[presetIndex]["colors"] = Defaults.colorListsToStringList(newColorLists) as AnyObject
        }
        get
        {
            return Defaults.stringListToColorLists(presets[presetIndex]["colors"] as! [String])
        }
    }
    
    static func colorListsToStringList(_ colorLists: [[NSColor]]) -> [String]
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

    static func stringListToColorLists(_ stringLists: [String]) -> [[NSColor]]
    {
        var lists:[[NSColor]] = []
        for list in stringLists
        {
            let hexList = list.split {$0 == "#"}.map { String($0) }
            var colorList:[NSColor] = []
            for hexColor in hexList
            {
                var r:UInt32 = 0
                var g:UInt32 = 0
                var b:UInt32 = 0
                Scanner(string:hexColor.substring(0,2)).scanHexInt32(&r)
                Scanner(string:hexColor.substring(2,2)).scanHexInt32(&g)
                Scanner(string:hexColor.substring(4,2)).scanHexInt32(&b)
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
    
    static func presetValueForKey(_ preset:[String: AnyObject], key:String) -> AnyObject?
    {
        let vals: [String: AnyObject] = preset["values"] as! Dictionary
        return vals[key]
    }
    
    func valueForKey(_ key:String) -> AnyObject?
    {
        return self.values[key]
    }
        
    func setObjectForKey(_ object: AnyObject, key: String)
    {
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: object), forKey: key)
        userDefaults.synchronize()
    }

    func getObjectForKey(_ key: String) -> AnyObject?
    {
        if let dictData = userDefaults.object(forKey: key) as? Data
        {
            return NSKeyedUnarchiver.unarchiveObject(with: dictData) as AnyObject
        }
        return nil;
    }    
}
