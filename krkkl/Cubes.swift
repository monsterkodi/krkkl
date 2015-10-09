/*
   0000000  000   000  0000000    00000000   0000000
  000       000   000  000   000  000       000     
  000       000   000  0000000    0000000   0000000 
  000       000   000  000   000  000            000
   0000000   0000000   0000000    00000000  0000000 
*/
import AppKit

enum Side:      Int { case UP = 0, RIGHT, LEFT, DOWN, BACKL, BACKR, NONE }
enum ColorType: Int { case RANDOM=0, LIST, DIRECTION, NUM }

class Cubes
{
    var preset:[String: AnyObject]?
    var fps:Double = 60
    var cpf:Double = 60
    var cubeSize:(x: Int, y: Int) = (0, 0)
    var pos:     (x: Int, y: Int) = (0, 0)
    var size:    (x: Int, y: Int) = (0, 0)
    var center:  (x: Int, y: Int) = (0, 0)
    var color_top:Double = 0
    var color_left:Double = 0
    var color_right:Double = 0

    var lastDir:Int = 0
    var nextDir:Int = 0
    var dirIncr:Int = 0
    var probSum:Double = 0
    var probDir:[Double] = [0,0,0]
    var keepDir:[Double] = [0,0,0]
    var reset:String = "" // what happens when the screen border is touched: "random", "ping", "wrap" ("center")
    
    var cubeCount:Int = 0
    var maxCubes:Int = 5000

    var colorType = ColorType.LIST
    var colorFade:Float = 0
    var colorInc:Float = 0
    var colorIndex:Int = 0
    var colorList:[NSColor] = []
    var thisColor  = colorRGB([0,0,0])
    var nextColor  = colorRGB([0,0,0])
    var resetColor = colorRGB([0,0,0])
    var rgbColor   = colorRGB([0,0,0])

    func isDone() -> Bool { return cubeCount >= maxCubes }
    func nextStep()
    {
        for _ in 0...Int(cpf)
        {
            drawNextCube()
        }
    }

    /*
       0000000  00000000  000000000  000   000  00000000 
      000       000          000     000   000  000   000
      0000000   0000000      000     000   000  00000000 
           000  000          000     000   000  000      
      0000000   00000000     000      0000000   000      
    */

    func setup(preview: Bool, width: Int, height: Int)
    {
        color_top   = randDblPref("color_top")
        color_left  = randDblPref("color_left")
        color_right = randDblPref("color_right")
        
        dirIncr = randChoice("dir_inc") as! Int

        size.y = Int(randDblPref("rows")) / (preview ? 2 : 1)

        cubeSize.y = height/size.y
        if (cubeSize.y % 2 == 1) { cubeSize.y -= 1 }
        cubeSize.y = max(2, cubeSize.y)
        size.y = height/cubeSize.y
        cubeSize.x = Int(sin(M_PI/3) * Double(cubeSize.y))
        size.x = width/cubeSize.x

        colorInc = Float(randDblPref("color_fade"))
        
        maxCubes = Int(Double(size.y * size.y)*randDblPref("cube_amount"))
        reset = randChoice("reset") as! String
        
        // _______________________ derivatives

        cpf = randDblPref("cpf")
        fps = doublePref("fps")

        center.x = size.x/2
        center.y = size.y/2
        pos = center // start at center

        colorFade = 0
        colorIndex = 0

        let colorLists = Defaults.stringListToColorLists(preset!["colors"] as! [String])
        let colorListIndex = randint(colorLists.count)        
        colorList = colorLists[colorListIndex]
        
        if (colorList.count == 0)
        {
            colorType = .RANDOM
        }
        else if (colorList.count == 1 && colorList[0].hex() == "#000000")
        {
            colorType = .DIRECTION
        }
        else
        {
            colorType = .LIST
        }

        thisColor = colorRGB([0,0,0])
        switch colorType
        {
        case .RANDOM:
            nextColor = randColor()
        case .LIST:
            thisColor = colorList[0]
            nextColor = colorList[0]
        default: break
        }
        
        rgbColor = thisColor
                
        keepDir[Side.UP.rawValue]    = randDblPref("keep_up")
        keepDir[Side.LEFT.rawValue]  = randDblPref("keep_left")
        keepDir[Side.RIGHT.rawValue] = randDblPref("keep_right")
        
        probDir[Side.UP.rawValue]    = randDblPref("prob_up")
        probDir[Side.LEFT.rawValue]  = randDblPref("prob_left")
        probDir[Side.RIGHT.rawValue] = randDblPref("prob_right")
        probSum = probDir.reduce(0.0, combine: { $0 + $1 })

        cubeCount = 0
        
        if false
        {
            print("")
            print("width \(width)")
            print("height \(height)")
            print("numx \(size.x)")
            print("numy \(size.y)")
            print("cube  \(cubeSize.x) \(cubeSize.y)")
            print("maxCubes \(maxCubes)")
            print("fps \(fps)")
            print("cpf \(cpf)")
            print("keepDir \(keepDir)")
            print("probDir \(probDir)")
            print("probSum \(probSum)")
            print("colorInc \(colorInc)")
            print("colorList \(colorListIndex)")
            print("colorType \(colorTypeName(colorType))")
            print("reset \(reset)")
        }
    }

    /*
       0000000   0000000   000       0000000   00000000 
      000       000   000  000      000   000  000   000
      000       000   000  000      000   000  0000000  
      000       000   000  000      000   000  000   000
       0000000   0000000   0000000   0000000   000   000
    */
    
    func chooseNextColor()
    {
        switch colorType
        {
        case .RANDOM:
            colorFade += colorInc
            if colorFade >= 100
            {
                colorFade -= 100
                thisColor = nextColor
                nextColor = randColor()
            }
            rgbColor = thisColor.fadeTo(nextColor, fade:colorFade/100.0)

        case .LIST:
            colorFade += colorInc
            if colorFade >= 100
            {
                colorFade -= 100
                colorIndex = (colorIndex + 1) % colorList.count
                thisColor = nextColor
                nextColor = colorList[colorIndex]
            }
            rgbColor = thisColor.fadeTo(nextColor, fade:colorFade/100.0)
            
        case .DIRECTION:
            let ci = 0.02 + 0.05 * colorInc/100.0
            var r = Float(rgbColor.red())
            var g = Float(rgbColor.green())
            var b = Float(rgbColor.blue())
            let side:Side = Side(rawValue:nextDir)!
            switch side
            {
            case .UP:    b = clamp(b + ci, low: 0.0, high: 1.0)
            case .LEFT:  r = clamp(r + ci, low: 0.0, high: 1.0)
            case .RIGHT: g = clamp(g + ci, low: 0.0, high: 1.0)
            case .DOWN:  b = clamp(b - ci, low: 0.0, high: 1.0)
            case .BACKR: r = clamp(r - ci, low: 0.0, high: 1.0)
            case .BACKL: g = clamp(g - ci, low: 0.0, high: 1.0)
            default: break
            }
            if r+g+b < 0.3
            {
                (r,g,b) = (0.1, 0.1, 0.1)
            }
            rgbColor = colorRGB([r,g,b])

        default: break
        }
    }
    
    /*
       0000000  000   000  0000000    00000000
      000       000   000  000   000  000     
      000       000   000  0000000    0000000 
      000       000   000  000   000  000     
       0000000   0000000   0000000    00000000
    */
        
    func drawNextCube()
    {
        var skip = Side.NONE
        
        nextDir = lastDir
        
        if (randdbl() >= keepDir[lastDir%3])
        {
            if dirIncr == 3
            {
                switch randdbl()
                {
                case let (prob) where prob <= probDir[Side.UP.rawValue]/probSum:
                    nextDir = randint(2) == 0 ? Side.UP.rawValue : Side.DOWN.rawValue
                case let (prob) where (probDir[Side.UP.rawValue]/probSum <= prob) && (prob <= probDir[Side.UP.rawValue + Side.LEFT.rawValue]/probSum):
                    nextDir = randint(2) == 0 ? Side.LEFT.rawValue : Side.BACKR.rawValue
                default:
                    nextDir = randint(2) == 0 ? Side.RIGHT.rawValue : Side.BACKL.rawValue
                }
            }
            else
            {
                nextDir = (nextDir + dirIncr)%6
            }
        }

        lastDir = nextDir
        
        let side:Side = Side(rawValue:nextDir)!
        switch side
        {
        case .UP:
                pos.y += 1
            
        case .RIGHT:
                if (pos.x%2)==1 { pos.y -= 1 }
                pos.x += 1

        case .LEFT:
                if (pos.x%2)==1 { pos.y -= 1 }
                pos.x -= 1

        case .DOWN:
                pos.y -= 1
                if cubeCount > 0 { skip = .UP }

        case .BACKL:
                if (pos.x%2)==0 { pos.y += 1 }
                pos.x -= 1
                if cubeCount > 0 { skip = .RIGHT }

        case .BACKR:
                if (pos.x%2)==0 { pos.y += 1 }
                pos.x += 1
                if cubeCount > 0 { skip = .LEFT }
            
        default:
                break
        }

        if (pos.x < 1 || pos.y < 2 || pos.x > size.x-1 || pos.y > size.y-1)  // if screen border is touched
        {
            skip = .NONE
            lastDir = randint(6)

            if reset == "center" 
            {
                pos.x = center.x
                pos.y = center.y
            }
            else if reset == "random" 
            {
                pos.x = randint(size.x)
                pos.y = randint(size.y)
            }
            else if reset == "wrap" 
            {
                if      (pos.x < 1)        { pos.x = size.x-1 }   
                else if (pos.x > size.x-1) { pos.x = 1 }
                if      (pos.y < 2)        { pos.y = size.y-2 }
                else if (pos.y > size.y-1) { pos.y = 2 }
            }
            else if reset == "ping" 
            {
                if (pos.x < 1)
                {
                    switch side
                    {
                    case .LEFT: lastDir = Side.BACKR.rawValue
                    default:    lastDir = Side.RIGHT.rawValue
                    }
                    pos.x = 1
                }
                else if (pos.x > size.x-1)
                {
                    switch side
                    {
                    case .BACKR: lastDir = Side.LEFT.rawValue
                    default:     lastDir = Side.BACKL.rawValue
                    }
                    pos.x = size.x-1
                }
                if (pos.y < 2)
                { 
                    switch side 
                    {
                    case .LEFT:  lastDir = Side.BACKR.rawValue
                    case .RIGHT: lastDir = Side.BACKL.rawValue
                    default:     lastDir = randflt()>0.5 ? Side.BACKL.rawValue : Side.BACKR.rawValue
                    }
                    pos.y = 2
                }
                else if (pos.y > size.y-1)
                { 
                    switch side 
                    {
                    case .BACKR: lastDir = Side.LEFT.rawValue
                    case .BACKL: lastDir = Side.RIGHT.rawValue
                    default:     lastDir = randflt()>0.5 ? Side.LEFT.rawValue : Side.RIGHT.rawValue
                    }
                    pos.y = size.y-1
                }
            }
            
            if colorType == ColorType.DIRECTION && ["center", "random"].indexOf(reset) != nil {
                rgbColor = colorRGB([0,0,0])
            }
        }

        chooseNextColor()
        drawCube(skip)
        
        cubeCount += 1
    }
    
    /*
      0000000    00000000    0000000   000   000
      000   000  000   000  000   000  000 0 000
      000   000  0000000    000000000  000000000
      000   000  000   000  000   000  000   000
      0000000    000   000  000   000  00     00
    */
    
    func drawCube(skip: Side)
    {
        let w = cubeSize.x
        let h = cubeSize.y
        
        let s = h/2
        let x = pos.x*w
        let y = (pos.x%2 == 0) ? (pos.y*h) : (pos.y*h - s)
        
        if skip != .UP
        {
            rgbColor.scale(color_top).set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x   ,y: y))
            path.lineToPoint(NSPoint(x: x+w ,y: y+s))
            path.lineToPoint(NSPoint(x: x   ,y: y+h))
            path.lineToPoint(NSPoint(x: x-w ,y: y+s))
            path.fill()
        }
        
        if skip != .LEFT
        {
            rgbColor.scale(color_left).set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x    ,y: y))
            path.lineToPoint(NSPoint(x: x-w  ,y: y+s))
            path.lineToPoint(NSPoint(x: x-w  ,y: y-s))
            path.lineToPoint(NSPoint(x: x    ,y: y-h))
            path.fill()
        }
        
        if skip != .RIGHT
        {
            rgbColor.scale(color_right).set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x    ,y: y))
            path.lineToPoint(NSPoint(x: x+w  ,y: y+s))
            path.lineToPoint(NSPoint(x: x+w  ,y: y-s))
            path.lineToPoint(NSPoint(x: x    ,y: y-h))
            path.fill()
        }
    }

    func randDblPref(key:String) -> Double
    {
        let dbls = doublesPref(key)
        return randdblrng(dbls[0], high: dbls[1])
    }
    
    func randChoice(key:String) -> AnyObject
    {
        let values = (Defaults.presetValueForKey(preset!, key: key) as! [String: AnyObject])["values"] as! [AnyObject]
        return values[randint(values.count)]
    }

    func doublePref(key:String) -> Double
    {
        return (Defaults.presetValueForKey(preset!, key: key) as! [String: AnyObject])["value"] as! Double
    }

    func doublesPref(key:String) -> [Double]
    {
        let doubleValue = Defaults.presetValueForKey(preset!, key: key) as! [String: AnyObject]
        return doubleValue["values"] as! [Double]
    }
    
    func colorTypeName(colorType:ColorType) -> String  
    {
        switch colorType
        {
            case .RANDOM:    return "Random" 
            case .LIST:      return "List"
            case .DIRECTION: return "Direction"
            case .NUM:       return "???"
        }
    }
}
