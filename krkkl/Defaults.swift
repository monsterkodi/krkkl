import ScreenSaver

let defaultValues:[[String: AnyObject]] = [
    [                        "title": "",                        "text": "values are choosen randomly between top and bottom sliders"],
    ["key": "rows",          "title": "number of cube rows",     "values": [20,  60],   "range":  [10,   100], "step": 1   ],
    ["key": "cube_amount",   "title": "cube amount",             "values": [3,    5],   "range":  [1,     10], "step": 0.2 ],
    ["key": "cpf",           "title": "cubes per frame",         "values": [1,    1],   "range":  [1,    200], "step": 1   ],
    [                        "title": "",                        "text": "how the next direction is choosen"],
    ["key": "reset",         "title": "border behaviour",        "values": ["random", "ping", "wrap"], "choices":["random", "ping", "wrap"], "labels":["reset position", "reflect", "torus wrap"], "type": "string" ],
    ["key": "dir_inc",       "title": "direction increment",     "values": [1, 2, 3, 4, 5],            "choices":[1, 2, 3, 4, 5],            "labels":["+1", "+2", "random", "-2", "-1"], "type": "int" ],
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
    "#b51700#fe2500#ff9225#ffff00#00cc27#009700#005e00#000f6e#0432ff#585aff",
    "#3a3a3a#1305f1#3a3a3a#5a5aff#383838#e22ca0#383838#dc1e00#383838#d132d1",
    "#000000#d90000#ff6b00#ffba00#ffff00#ffba00#ff6b00#d90000#6e0000",
    "#000000#d90000#000000#ffffff#000000#f23e04#000000#515151",
    "#3b3d3b#c48655#e8d193#c48655#3b3d3b#8f8494#c8c9d1#8f8494#3b3d3b",
    "#f1d959#fe555e#7b526f#34497b#1f2348#04040e",
    "#6fa1ce#060f3d#2b4376#6a9ac0#bae2f6#eee5fa",
    "#ffe868#f7da35#bb9d00#937a00#785dc1#583aac#2c1583#1e0e67",
    "#257b4b#31a364#2f915a#1c653c#195232#ac8b32#e6ba43#cca640#8d7127#725c22#6b2472#8e3098#7d2c86#6b2472#46174b"
]

var defaultPresets:[[String: AnyObject]] = [[
    "values": defaultValues,
    "colors": defaultColors
    ]]

let defaultPresetsData = "WwogIHsKICAgICJjb2xvcnMiIDogWwogICAgICAiIzZjMDAwMCNiNTAwMDAjZmYwMDAwI2ZmOTIyNyNiNTAwMDAiLAogICAgICAiIzAwM2EwMCMwMDVlMDAjMDA5NzAwIzAwY2QyNyMwMDVlMDAiLAogICAgICAiIzAwMDAyZiMwMDAwNmUjMDAwMGZmIzU5NWJmZiMwMDAwNmUiLAogICAgICAiIzMyMzIzMiM2NDY0NjQjYjNiM2IzI2ZmZmZmZiM1MTUxNTEiCiAgICBdLAogICAgInZhbHVlcyIgOiBbCiAgICAgIHsKICAgICAgICAidGl0bGUiIDogIiIsCiAgICAgICAgInRleHQiIDogInZhbHVlcyBhcmUgY2hvb3NlbiByYW5kb21seSBiZXR3ZWVuIHRvcCBhbmQgYm90dG9tIHNsaWRlcnMiCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMTAsCiAgICAgICAgICAxMDAKICAgICAgICBdLAogICAgICAgICJ0aXRsZSIgOiAibnVtYmVyIG9mIGN1YmUgcm93cyIsCiAgICAgICAgImtleSIgOiAicm93cyIsCiAgICAgICAgInN0ZXAiIDogMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDMzLAogICAgICAgICAgNjYKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMSwKICAgICAgICAgIDEwCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogImN1YmUgYW1vdW50IiwKICAgICAgICAia2V5IiA6ICJjdWJlX2Ftb3VudCIsCiAgICAgICAgInN0ZXAiIDogMC4yLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMiwKICAgICAgICAgIDMKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMSwKICAgICAgICAgIDIwMAogICAgICAgIF0sCiAgICAgICAgInRpdGxlIiA6ICJjdWJlcyBwZXIgZnJhbWUiLAogICAgICAgICJrZXkiIDogImNwZiIsCiAgICAgICAgInN0ZXAiIDogMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDEsCiAgICAgICAgICAxCiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInRpdGxlIiA6ICIiLAogICAgICAgICJ0ZXh0IiA6ICJob3cgdGhlIG5leHQgZGlyZWN0aW9uIGlzIGNob29zZW4iCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgICJyYW5kb20iLAogICAgICAgICAgIndyYXAiCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogImJvcmRlciBiZWhhdmlvdXIiLAogICAgICAgICJrZXkiIDogInJlc2V0IiwKICAgICAgICAidHlwZSIgOiAic3RyaW5nIiwKICAgICAgICAiY2hvaWNlcyIgOiBbCiAgICAgICAgICAicmFuZG9tIiwKICAgICAgICAgICJwaW5nIiwKICAgICAgICAgICJ3cmFwIgogICAgICAgIF0sCiAgICAgICAgImxhYmVscyIgOiBbCiAgICAgICAgICAicmVzZXQgcG9zaXRpb24iLAogICAgICAgICAgInJlZmxlY3QiLAogICAgICAgICAgInRvcnVzIHdyYXAiCiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgNQogICAgICAgIF0sCiAgICAgICAgInRpdGxlIiA6ICJkaXJlY3Rpb24gaW5jcmVtZW50IiwKICAgICAgICAia2V5IiA6ICJkaXJfaW5jIiwKICAgICAgICAidHlwZSIgOiAiaW50IiwKICAgICAgICAiY2hvaWNlcyIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMiwKICAgICAgICAgIDMsCiAgICAgICAgICA0LAogICAgICAgICAgNQogICAgICAgIF0sCiAgICAgICAgImxhYmVscyIgOiBbCiAgICAgICAgICAiKzEiLAogICAgICAgICAgIisyIiwKICAgICAgICAgICJyYW5kb20iLAogICAgICAgICAgIi0yIiwKICAgICAgICAgICItMSIKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidGl0bGUiIDogImRpcmVjdGlvbiBwcm9iYWJpbGl0eSIsCiAgICAgICAgInRleHQiIDogInVzZWQgd2hlbiBkaXJlY3Rpb24gaW5jcmVtZW50IGlzIHJhbmRvbSIKICAgICAgfSwKICAgICAgewogICAgICAgICJsYWJlbCIgOiAidXAiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMC45OQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAicHJvYl91cCIsCiAgICAgICAgInN0ZXAiIDogMC4wMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDAuOTksCiAgICAgICAgICAwLjk5CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJsZWZ0IiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdLAogICAgICAgICJrZXkiIDogInByb2JfbGVmdCIsCiAgICAgICAgInN0ZXAiIDogMC4wMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDAuOTksCiAgICAgICAgICAwLjk5CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJyaWdodCIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAwLjk5CiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJwcm9iX3JpZ2h0IiwKICAgICAgICAic3RlcCIgOiAwLjAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMC45OSwKICAgICAgICAgIDAuOTkKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidGl0bGUiIDogImtlZXAgZGlyZWN0aW9uIiwKICAgICAgICAidGV4dCIgOiAiaGlnaGVyIHZhbHVlcyB5aWVsZCBsb25nZXIgc3RyYWlnaHQgbGluZXMiCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogInVwIiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdLAogICAgICAgICJrZXkiIDogImtlZXBfdXAiLAogICAgICAgICJzdGVwIiA6IDAuMDEsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAwLjU2MDAwMDAwMDAwMDAwMDEsCiAgICAgICAgICAwLjU2MDAwMDAwMDAwMDAwMDEKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogImxlZnQiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMC45OQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAia2VlcF9sZWZ0IiwKICAgICAgICAic3RlcCIgOiAwLjAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMC40LAogICAgICAgICAgMC40CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJyaWdodCIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAwLjk5CiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJrZWVwX3JpZ2h0IiwKICAgICAgICAic3RlcCIgOiAwLjAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMC4yMywKICAgICAgICAgIDAuMjQKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidGl0bGUiIDogIiIsCiAgICAgICAgInRleHQiIDogImxvd2VyIHZhbHVlcyB5aWVsZCBzbW9vdGhlciBjb2xvciBmYWRlcyIKICAgICAgfSwKICAgICAgewogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMTAwCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogImNvbG9yIGNoYW5nZSBzcGVlZCIsCiAgICAgICAgImtleSIgOiAiY29sb3JfZmFkZSIsCiAgICAgICAgInN0ZXAiIDogMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDcsCiAgICAgICAgICA3CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInRpdGxlIiA6ICJicmlnaHRuZXNzIiwKICAgICAgICAidGV4dCIgOiAibG93ZXIgdmFsdWVzIHlpZWxkIGRhcmtlciBjb2xvcnMiCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogInRvcCBzaWRlIiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDEKICAgICAgICBdLAogICAgICAgICJrZXkiIDogImNvbG9yX3RvcCIsCiAgICAgICAgInN0ZXAiIDogMC4wNSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDEsCiAgICAgICAgICAxCiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJsZWZ0IHNpZGUiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAiY29sb3JfbGVmdCIsCiAgICAgICAgInN0ZXAiIDogMC4wNSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDAuNjAwMDAwMDAwMDAwMDAwMSwKICAgICAgICAgIDAuNgogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJsYWJlbCIgOiAicmlnaHQgc2lkZSIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAxCiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJjb2xvcl9yaWdodCIsCiAgICAgICAgInN0ZXAiIDogMC4wNSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDAuMywKICAgICAgICAgIDAuMwogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJ0aXRsZSIgOiAiIiwKICAgICAgICAidGV4dCIgOiAiIgogICAgICB9LAogICAgICB7CiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDEsCiAgICAgICAgICA2MAogICAgICAgIF0sCiAgICAgICAgInRpdGxlIiA6ICJmcmFtZXMgcGVyIHNlY29uZCIsCiAgICAgICAgInZhbHVlIiA6IDYwLAogICAgICAgICJzdGVwIiA6IDEsCiAgICAgICAgImtleSIgOiAiZnBzIgogICAgICB9LAogICAgICB7CiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDEwLAogICAgICAgICAgMjQwCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogImZhZGUgZHVyYXRpb24gaW4gZnJhbWVzIiwKICAgICAgICAidmFsdWUiIDogMTAwLAogICAgICAgICJzdGVwIiA6IDEsCiAgICAgICAgImtleSIgOiAiZmFkZSIKICAgICAgfQogICAgXQogIH0sCiAgewogICAgImNvbG9ycyIgOiBbCiAgICAgICIjM2IzZDNiI2M0ODY1NSNlOGQxOTMjYzQ4NjU1IzNiM2QzYiM4Zjg0OTQjYzhjOWQxIzhmODQ5NCMzYjNkM2IiLAogICAgICAiIzZmYTFjZSMwNjBmM2QjMmI0Mzc2IzZhOWFjMCNiYWUyZjYjZWVlNWZhIgogICAgXSwKICAgICJ2YWx1ZXMiIDogWwogICAgICB7CiAgICAgICAgInRpdGxlIiA6ICIiLAogICAgICAgICJ0ZXh0IiA6ICJ2YWx1ZXMgYXJlIGNob29zZW4gcmFuZG9tbHkgYmV0d2VlbiB0b3AgYW5kIGJvdHRvbSBzbGlkZXJzIgogICAgICB9LAogICAgICB7CiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDEwLAogICAgICAgICAgMTAwCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogIm51bWJlciBvZiBjdWJlIHJvd3MiLAogICAgICAgICJrZXkiIDogInJvd3MiLAogICAgICAgICJzdGVwIiA6IDEsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICA1MCwKICAgICAgICAgIDEwMAogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMTAKICAgICAgICBdLAogICAgICAgICJ0aXRsZSIgOiAiY3ViZSBhbW91bnQiLAogICAgICAgICJrZXkiIDogImN1YmVfYW1vdW50IiwKICAgICAgICAic3RlcCIgOiAwLjIsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAyLAogICAgICAgICAgMy44CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDEsCiAgICAgICAgICAyMDAKICAgICAgICBdLAogICAgICAgICJ0aXRsZSIgOiAiY3ViZXMgcGVyIGZyYW1lIiwKICAgICAgICAia2V5IiA6ICJjcGYiLAogICAgICAgICJzdGVwIiA6IDEsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMQogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJ0aXRsZSIgOiAiIiwKICAgICAgICAidGV4dCIgOiAiaG93IHRoZSBuZXh0IGRpcmVjdGlvbiBpcyBjaG9vc2VuIgogICAgICB9LAogICAgICB7CiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAicGluZyIKICAgICAgICBdLAogICAgICAgICJ0aXRsZSIgOiAiYm9yZGVyIGJlaGF2aW91ciIsCiAgICAgICAgImtleSIgOiAicmVzZXQiLAogICAgICAgICJ0eXBlIiA6ICJzdHJpbmciLAogICAgICAgICJjaG9pY2VzIiA6IFsKICAgICAgICAgICJyYW5kb20iLAogICAgICAgICAgInBpbmciLAogICAgICAgICAgIndyYXAiCiAgICAgICAgXSwKICAgICAgICAibGFiZWxzIiA6IFsKICAgICAgICAgICJyZXNldCBwb3NpdGlvbiIsCiAgICAgICAgICAicmVmbGVjdCIsCiAgICAgICAgICAidG9ydXMgd3JhcCIKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDQKICAgICAgICBdLAogICAgICAgICJ0aXRsZSIgOiAiZGlyZWN0aW9uIGluY3JlbWVudCIsCiAgICAgICAgImtleSIgOiAiZGlyX2luYyIsCiAgICAgICAgInR5cGUiIDogImludCIsCiAgICAgICAgImNob2ljZXMiIDogWwogICAgICAgICAgMSwKICAgICAgICAgIDIsCiAgICAgICAgICAzLAogICAgICAgICAgNCwKICAgICAgICAgIDUKICAgICAgICBdLAogICAgICAgICJsYWJlbHMiIDogWwogICAgICAgICAgIisxIiwKICAgICAgICAgICIrMiIsCiAgICAgICAgICAicmFuZG9tIiwKICAgICAgICAgICItMiIsCiAgICAgICAgICAiLTEiCiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInRpdGxlIiA6ICJkaXJlY3Rpb24gcHJvYmFiaWxpdHkiLAogICAgICAgICJ0ZXh0IiA6ICJ1c2VkIHdoZW4gZGlyZWN0aW9uIGluY3JlbWVudCBpcyByYW5kb20iCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogInVwIiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdLAogICAgICAgICJrZXkiIDogInByb2JfdXAiLAogICAgICAgICJzdGVwIiA6IDAuMDEsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAwLjk5LAogICAgICAgICAgMC45OQogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJsYWJlbCIgOiAibGVmdCIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAwLjk5CiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJwcm9iX2xlZnQiLAogICAgICAgICJzdGVwIiA6IDAuMDEsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAwLjk5LAogICAgICAgICAgMC45OQogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJsYWJlbCIgOiAicmlnaHQiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMC45OQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAicHJvYl9yaWdodCIsCiAgICAgICAgInN0ZXAiIDogMC4wMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDAuOTksCiAgICAgICAgICAwLjk5CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInRpdGxlIiA6ICJrZWVwIGRpcmVjdGlvbiIsCiAgICAgICAgInRleHQiIDogImhpZ2hlciB2YWx1ZXMgeWllbGQgbG9uZ2VyIHN0cmFpZ2h0IGxpbmVzIgogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJ1cCIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAwLjk5CiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJrZWVwX3VwIiwKICAgICAgICAic3RlcCIgOiAwLjAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMC45OSwKICAgICAgICAgIDAuOTkKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogImxlZnQiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMC45OQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAia2VlcF9sZWZ0IiwKICAgICAgICAic3RlcCIgOiAwLjAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMC45OSwKICAgICAgICAgIDAuOTkKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogInJpZ2h0IiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdLAogICAgICAgICJrZXkiIDogImtlZXBfcmlnaHQiLAogICAgICAgICJzdGVwIiA6IDAuMDEsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAwLjk5LAogICAgICAgICAgMC45OQogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJ0aXRsZSIgOiAiIiwKICAgICAgICAidGV4dCIgOiAibG93ZXIgdmFsdWVzIHlpZWxkIHNtb290aGVyIGNvbG9yIGZhZGVzIgogICAgICB9LAogICAgICB7CiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDEsCiAgICAgICAgICAxMDAKICAgICAgICBdLAogICAgICAgICJ0aXRsZSIgOiAiY29sb3IgY2hhbmdlIHNwZWVkIiwKICAgICAgICAia2V5IiA6ICJjb2xvcl9mYWRlIiwKICAgICAgICAic3RlcCIgOiAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMSwKICAgICAgICAgIDEKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidGl0bGUiIDogImJyaWdodG5lc3MiLAogICAgICAgICJ0ZXh0IiA6ICJsb3dlciB2YWx1ZXMgeWllbGQgZGFya2VyIGNvbG9ycyIKICAgICAgfSwKICAgICAgewogICAgICAgICJsYWJlbCIgOiAidG9wIHNpZGUiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAiY29sb3JfdG9wIiwKICAgICAgICAic3RlcCIgOiAwLjA1LAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMSwKICAgICAgICAgIDEKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogImxlZnQgc2lkZSIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAxCiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJjb2xvcl9sZWZ0IiwKICAgICAgICAic3RlcCIgOiAwLjA1LAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMC42MDAwMDAwMDAwMDAwMDAxLAogICAgICAgICAgMC42CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJyaWdodCBzaWRlIiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDEKICAgICAgICBdLAogICAgICAgICJrZXkiIDogImNvbG9yX3JpZ2h0IiwKICAgICAgICAic3RlcCIgOiAwLjA1LAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMC4zLAogICAgICAgICAgMC4zCiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInRpdGxlIiA6ICIiLAogICAgICAgICJ0ZXh0IiA6ICIiCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMSwKICAgICAgICAgIDYwCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogImZyYW1lcyBwZXIgc2Vjb25kIiwKICAgICAgICAidmFsdWUiIDogNjAsCiAgICAgICAgInN0ZXAiIDogMSwKICAgICAgICAia2V5IiA6ICJmcHMiCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMTAsCiAgICAgICAgICAyNDAKICAgICAgICBdLAogICAgICAgICJ0aXRsZSIgOiAiZmFkZSBkdXJhdGlvbiBpbiBmcmFtZXMiLAogICAgICAgICJ2YWx1ZSIgOiAxMDAsCiAgICAgICAgInN0ZXAiIDogMSwKICAgICAgICAia2V5IiA6ICJmYWRlIgogICAgICB9CiAgICBdCiAgfSwKICB7CiAgICAiY29sb3JzIiA6IFsKICAgICAgIiNiNTE3MDAjZmUyNTAwI2ZmOTIyNSNmZmZmMDAjMDBjYzI3IzAwOTcwMCMwMDVlMDAjMDAwZjZlIzA0MzJmZiM1ODVhZmYiLAogICAgICAiI2YxZDk1OSNmZTU1NWUjN2I1MjZmIzM0NDk3YiMxZjIzNDgjMDQwNDBlIiwKICAgICAgIiNmZmU4NjgjZjdkYTM1I2JiOWQwMCM5MzdhMDAjNzg1ZGMxIzU4M2FhYyMyYzE1ODMjMWUwZTY3IiwKICAgICAgIiMyNTdiNGIjMzFhMzY0IzJmOTE1YSMxYzY1M2MjMTk1MjMyI2FjOGIzMiNlNmJhNDMjY2NhNjQwIzhkNzEyNyM3MjVjMjIjNmIyNDcyIzhlMzA5OCM3ZDJjODYjNmIyNDcyIzQ2MTc0YiIKICAgIF0sCiAgICAidmFsdWVzIiA6IFsKICAgICAgewogICAgICAgICJ0aXRsZSIgOiAiIiwKICAgICAgICAidGV4dCIgOiAidmFsdWVzIGFyZSBjaG9vc2VuIHJhbmRvbWx5IGJldHdlZW4gdG9wIGFuZCBib3R0b20gc2xpZGVycyIKICAgICAgfSwKICAgICAgewogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAxMCwKICAgICAgICAgIDEwMAogICAgICAgIF0sCiAgICAgICAgInRpdGxlIiA6ICJudW1iZXIgb2YgY3ViZSByb3dzIiwKICAgICAgICAia2V5IiA6ICJyb3dzIiwKICAgICAgICAic3RlcCIgOiAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMjAsCiAgICAgICAgICA4MAogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMTAKICAgICAgICBdLAogICAgICAgICJ0aXRsZSIgOiAiY3ViZSBhbW91bnQiLAogICAgICAgICJrZXkiIDogImN1YmVfYW1vdW50IiwKICAgICAgICAic3RlcCIgOiAwLjIsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAzLAogICAgICAgICAgNQogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMjAwCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogImN1YmVzIHBlciBmcmFtZSIsCiAgICAgICAgImtleSIgOiAiY3BmIiwKICAgICAgICAic3RlcCIgOiAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMSwKICAgICAgICAgIDEKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidGl0bGUiIDogIiIsCiAgICAgICAgInRleHQiIDogImhvdyB0aGUgbmV4dCBkaXJlY3Rpb24gaXMgY2hvb3NlbiIKICAgICAgfSwKICAgICAgewogICAgICAgICJsYWJlbHMiIDogWwogICAgICAgICAgInJlc2V0IHBvc2l0aW9uIiwKICAgICAgICAgICJyZWZsZWN0IiwKICAgICAgICAgICJ0b3J1cyB3cmFwIgogICAgICAgIF0sCiAgICAgICAgInRpdGxlIiA6ICJib3JkZXIgYmVoYXZpb3VyIiwKICAgICAgICAia2V5IiA6ICJyZXNldCIsCiAgICAgICAgInR5cGUiIDogInN0cmluZyIsCiAgICAgICAgImNob2ljZXMiIDogWwogICAgICAgICAgInJhbmRvbSIsCiAgICAgICAgICAicGluZyIsCiAgICAgICAgICAid3JhcCIKICAgICAgICBdLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgInJhbmRvbSIsCiAgICAgICAgICAid3JhcCIKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWxzIiA6IFsKICAgICAgICAgICIrMSIsCiAgICAgICAgICAiKzIiLAogICAgICAgICAgInJhbmRvbSIsCiAgICAgICAgICAiLTIiLAogICAgICAgICAgIi0xIgogICAgICAgIF0sCiAgICAgICAgInRpdGxlIiA6ICJkaXJlY3Rpb24gaW5jcmVtZW50IiwKICAgICAgICAia2V5IiA6ICJkaXJfaW5jIiwKICAgICAgICAidHlwZSIgOiAiaW50IiwKICAgICAgICAiY2hvaWNlcyIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMiwKICAgICAgICAgIDMsCiAgICAgICAgICA0LAogICAgICAgICAgNQogICAgICAgIF0sCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMiwKICAgICAgICAgIDMsCiAgICAgICAgICA0LAogICAgICAgICAgNQogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJ0aXRsZSIgOiAiZGlyZWN0aW9uIHByb2JhYmlsaXR5IiwKICAgICAgICAidGV4dCIgOiAidXNlZCB3aGVuIGRpcmVjdGlvbiBpbmNyZW1lbnQgaXMgcmFuZG9tIgogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJ1cCIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAwLjk5CiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJwcm9iX3VwIiwKICAgICAgICAic3RlcCIgOiAwLjAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogImxlZnQiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMC45OQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAicHJvYl9sZWZ0IiwKICAgICAgICAic3RlcCIgOiAwLjAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAibGFiZWwiIDogInJpZ2h0IiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdLAogICAgICAgICJrZXkiIDogInByb2JfcmlnaHQiLAogICAgICAgICJzdGVwIiA6IDAuMDEsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMC45OQogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJ0aXRsZSIgOiAia2VlcCBkaXJlY3Rpb24iLAogICAgICAgICJ0ZXh0IiA6ICJoaWdoZXIgdmFsdWVzIHlpZWxkIGxvbmdlciBzdHJhaWdodCBsaW5lcyIKICAgICAgfSwKICAgICAgewogICAgICAgICJsYWJlbCIgOiAidXAiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMC45OQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAia2VlcF91cCIsCiAgICAgICAgInN0ZXAiIDogMC4wMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAwLjk5CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJsZWZ0IiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdLAogICAgICAgICJrZXkiIDogImtlZXBfbGVmdCIsCiAgICAgICAgInN0ZXAiIDogMC4wMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAwLjk5CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJyaWdodCIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAwLjk5CiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJrZWVwX3JpZ2h0IiwKICAgICAgICAic3RlcCIgOiAwLjAxLAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDAuOTkKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidGl0bGUiIDogIiIsCiAgICAgICAgInRleHQiIDogImxvd2VyIHZhbHVlcyB5aWVsZCBzbW9vdGhlciBjb2xvciBmYWRlcyIKICAgICAgfSwKICAgICAgewogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAxLAogICAgICAgICAgMTAwCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogImNvbG9yIGNoYW5nZSBzcGVlZCIsCiAgICAgICAgImtleSIgOiAiY29sb3JfZmFkZSIsCiAgICAgICAgInN0ZXAiIDogMSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDEsCiAgICAgICAgICAyMAogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJ0aXRsZSIgOiAiYnJpZ2h0bmVzcyIsCiAgICAgICAgInRleHQiIDogImxvd2VyIHZhbHVlcyB5aWVsZCBkYXJrZXIgY29sb3JzIgogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJ0b3Agc2lkZSIsCiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDAsCiAgICAgICAgICAxCiAgICAgICAgXSwKICAgICAgICAia2V5IiA6ICJjb2xvcl90b3AiLAogICAgICAgICJzdGVwIiA6IDAuMDUsCiAgICAgICAgInZhbHVlcyIgOiBbCiAgICAgICAgICAwLjEsCiAgICAgICAgICAwLjM1CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJsZWZ0IHNpZGUiLAogICAgICAgICJyYW5nZSIgOiBbCiAgICAgICAgICAwLAogICAgICAgICAgMQogICAgICAgIF0sCiAgICAgICAgImtleSIgOiAiY29sb3JfbGVmdCIsCiAgICAgICAgInN0ZXAiIDogMC4wNSwKICAgICAgICAidmFsdWVzIiA6IFsKICAgICAgICAgIDAuMTUsCiAgICAgICAgICAwLjU1CiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgImxhYmVsIiA6ICJyaWdodCBzaWRlIiwKICAgICAgICAicmFuZ2UiIDogWwogICAgICAgICAgMCwKICAgICAgICAgIDEKICAgICAgICBdLAogICAgICAgICJrZXkiIDogImNvbG9yX3JpZ2h0IiwKICAgICAgICAic3RlcCIgOiAwLjA1LAogICAgICAgICJ2YWx1ZXMiIDogWwogICAgICAgICAgMC41LAogICAgICAgICAgMQogICAgICAgIF0KICAgICAgfSwKICAgICAgewogICAgICAgICJ0aXRsZSIgOiAiIiwKICAgICAgICAidGV4dCIgOiAiIgogICAgICB9LAogICAgICB7CiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDEsCiAgICAgICAgICA2MAogICAgICAgIF0sCiAgICAgICAgInRpdGxlIiA6ICJmcmFtZXMgcGVyIHNlY29uZCIsCiAgICAgICAgInZhbHVlIiA6IDYwLAogICAgICAgICJzdGVwIiA6IDEsCiAgICAgICAgImtleSIgOiAiZnBzIgogICAgICB9LAogICAgICB7CiAgICAgICAgInJhbmdlIiA6IFsKICAgICAgICAgIDEwLAogICAgICAgICAgMjQwCiAgICAgICAgXSwKICAgICAgICAidGl0bGUiIDogImZhZGUgZHVyYXRpb24gaW4gZnJhbWVzIiwKICAgICAgICAidmFsdWUiIDogMTAwLAogICAgICAgICJzdGVwIiA6IDEsCiAgICAgICAgImtleSIgOiAiZmFkZSIKICAgICAgfQogICAgXQogIH0KXQ=="

class Defaults
{
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
    
    var values: [[String: AnyObject]]
    {
        set(newValues)
        {
            presets[presetIndex]["values"] = newValues
        }
        get
        {
            return presets[presetIndex]["values"] as! [[String: AnyObject]]
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
    
    static func presetValueForKey(preset:[String: AnyObject], key:String) -> AnyObject?
    {
        let vals = preset["values"]!
        for index in 0...vals.count
        {
            let v = vals[index]
            if (v["key"] as? String) == key
            {
                return vals[index]
            }
        }
        return nil
    }
    
    func valueForKey(key:String) -> AnyObject?
    {
        return self.values[rowForKey(key)]
    }
    
    func rowForKey(key:String) -> Int
    {
        for index in 0...self.values.count
        {
            let v = self.values[index]
            if (v["key"] as? String) == key
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
        if let dictData = userDefaults.objectForKey(key) as? NSData
        {
            return NSKeyedUnarchiver.unarchiveObjectWithData(dictData)
        }
        return nil;
    }    
}
