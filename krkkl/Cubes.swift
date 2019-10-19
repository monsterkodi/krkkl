/*
   0000000  000   000  0000000    00000000   0000000
  000       000   000  000   000  000       000     
  000       000   000  0000000    0000000   0000000 
  000       000   000  000   000  000            000
   0000000   0000000   0000000    00000000  0000000 
*/
import AppKit

enum Side:      Int { case up = 0, right, left, down, backl, backr, none }
enum ColorType: Int { case random=0, list, direction, num }
enum Reset:     Int { case random = 0, ping, wrap }

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
    var reset:Int = -1 // what happens when the screen border is touched: "random", "ping", "wrap" ("center")
    
    var cubeCount:Int = 0
    var maxCubes:Int = 5000

    var colorType = ColorType.list
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

    func setup(_ preview: Bool, width: Int, height: Int)
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
        cubeSize.x = Int(sin(Double.pi/3) * Double(cubeSize.y))
        size.x = width/cubeSize.x

        colorInc = Float(randDblPref("color_fade"))
        
        maxCubes = Int(Double(size.y * size.y)*randDblPref("cube_amount"))
        reset = randChoice("reset") as! Int
        
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
            colorType = .random
        }
        else if (colorList.count == 1 && colorList[0].hex() == "#000000")
        {
            colorType = .direction
        }
        else
        {
            colorType = .list
        }

        thisColor = colorRGB([0,0,0])
        switch colorType
        {
        case .random:
            nextColor = randColor()
        case .list:
            thisColor = colorList[0]
            nextColor = colorList[0]
        default: break
        }
        
        rgbColor = thisColor
                
        keepDir[Side.up.rawValue]    = randDblPref("keep_up")
        keepDir[Side.left.rawValue]  = randDblPref("keep_left")
        keepDir[Side.right.rawValue] = randDblPref("keep_right")
        
        probDir[Side.up.rawValue]    = randDblPref("prob_up")
        probDir[Side.left.rawValue]  = randDblPref("prob_left")
        probDir[Side.right.rawValue] = randDblPref("prob_right")
        probSum = probDir.reduce(0.0, { $0 + $1 })

        cubeCount = 0
        
        if true
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
        case .random:
            colorFade += colorInc
            if colorFade >= 100
            {
                colorFade -= 100
                thisColor = nextColor
                nextColor = randColor()
            }
            rgbColor = thisColor.fadeTo(nextColor, fade:colorFade/100.0)

        case .list:
            colorFade += colorInc
            if colorFade >= 100
            {
                colorFade -= 100
                colorIndex = (colorIndex + 1) % colorList.count
                thisColor = nextColor
                nextColor = colorList[colorIndex]
            }
            rgbColor = thisColor.fadeTo(nextColor, fade:colorFade/100.0)
            
        case .direction:
            let ci = 0.02 + 0.05 * colorInc/100.0
            var r = Float(rgbColor.red())
            var g = Float(rgbColor.green())
            var b = Float(rgbColor.blue())
            let side:Side = Side(rawValue:nextDir)!
            switch side
            {
            case .up:    b = clamp(b + ci, low: 0.0, high: 1.0)
            case .left:  r = clamp(r + ci, low: 0.0, high: 1.0)
            case .right: g = clamp(g + ci, low: 0.0, high: 1.0)
            case .down:  b = clamp(b - ci, low: 0.0, high: 1.0)
            case .backr: r = clamp(r - ci, low: 0.0, high: 1.0)
            case .backl: g = clamp(g - ci, low: 0.0, high: 1.0)
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
        var skip = Side.none
        
        nextDir = lastDir
        
        if (randdbl() >= keepDir[lastDir%3])
        {
            if dirIncr == 3
            {
                switch randdbl()
                {
                case let (prob) where prob <= probDir[Side.up.rawValue]/probSum:
                    nextDir = randint(2) == 0 ? Side.up.rawValue : Side.down.rawValue
                case let (prob) where (probDir[Side.up.rawValue]/probSum <= prob) && (prob <= probDir[Side.up.rawValue + Side.left.rawValue]/probSum):
                    nextDir = randint(2) == 0 ? Side.left.rawValue : Side.backr.rawValue
                default:
                    nextDir = randint(2) == 0 ? Side.right.rawValue : Side.backl.rawValue
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
        case .up:
                pos.y += 1
            
        case .right:
                if (pos.x%2)==1 { pos.y -= 1 }
                pos.x += 1

        case .left:
                if (pos.x%2)==1 { pos.y -= 1 }
                pos.x -= 1

        case .down:
                pos.y -= 1
                if cubeCount > 0 { skip = .up }

        case .backl:
                if (pos.x%2)==0 { pos.y += 1 }
                pos.x -= 1
                if cubeCount > 0 { skip = .right }

        case .backr:
                if (pos.x%2)==0 { pos.y += 1 }
                pos.x += 1
                if cubeCount > 0 { skip = .left }
            
        default:
                break
        }

        if (pos.x < 1 || pos.y < 2 || pos.x > size.x-1 || pos.y > size.y-1)  // if screen border is touched
        {
            skip = .none
            lastDir = randint(6)

            if reset == Reset.random.rawValue
            {
                pos.x = randint(size.x)
                pos.y = randint(size.y)
            }
            else if reset == Reset.wrap.rawValue
            {
                if      (pos.x < 1)        { pos.x = size.x-1 }   
                else if (pos.x > size.x-1) { pos.x = 1 }
                if      (pos.y < 2)        { pos.y = size.y-2 }
                else if (pos.y > size.y-1) { pos.y = 2 }
            }
            else if reset == Reset.ping.rawValue
            {
                if (pos.x < 1)
                {
                    switch side
                    {
                    case .left: lastDir = Side.backr.rawValue
                    default:    lastDir = Side.right.rawValue
                    }
                    pos.x = 1
                }
                else if (pos.x > size.x-1)
                {
                    switch side
                    {
                    case .backr: lastDir = Side.left.rawValue
                    default:     lastDir = Side.backl.rawValue
                    }
                    pos.x = size.x-1
                }
                if (pos.y < 2)
                { 
                    switch side 
                    {
                    case .left:  lastDir = Side.backr.rawValue
                    case .right: lastDir = Side.backl.rawValue
                    default:     lastDir = randflt()>0.5 ? Side.backl.rawValue : Side.backr.rawValue
                    }
                    pos.y = 2
                }
                else if (pos.y > size.y-1)
                { 
                    switch side 
                    {
                    case .backr: lastDir = Side.left.rawValue
                    case .backl: lastDir = Side.right.rawValue
                    default:     lastDir = randflt()>0.5 ? Side.left.rawValue : Side.right.rawValue
                    }
                    pos.y = size.y-1
                }
            }
            
            if colorType == ColorType.direction && reset == Reset.random.rawValue
            {
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
    
    func drawCube(_ skip: Side)
    {
        let w = cubeSize.x
        let h = cubeSize.y
        
        let s = h/2
        let x = pos.x*w
        let y = (pos.x%2 == 0) ? (pos.y*h) : (pos.y*h - s)
        
        if skip != .up
        {
            rgbColor.scale(color_top).set()
            let path = NSBezierPath()
            path.move(to: NSPoint(x: x   ,y: y))
            path.line(to: NSPoint(x: x+w ,y: y+s))
            path.line(to: NSPoint(x: x   ,y: y+h))
            path.line(to: NSPoint(x: x-w ,y: y+s))
            path.fill()
        }
        
        if skip != .left
        {
            rgbColor.scale(color_left).set()
            let path = NSBezierPath()
            path.move(to: NSPoint(x: x    ,y: y))
            path.line(to: NSPoint(x: x-w  ,y: y+s))
            path.line(to: NSPoint(x: x-w  ,y: y-s))
            path.line(to: NSPoint(x: x    ,y: y-h))
            path.fill()
        }
        
        if skip != .right
        {
            rgbColor.scale(color_right).set()
            let path = NSBezierPath()
            path.move(to: NSPoint(x: x    ,y: y))
            path.line(to: NSPoint(x: x+w  ,y: y+s))
            path.line(to: NSPoint(x: x+w  ,y: y-s))
            path.line(to: NSPoint(x: x    ,y: y-h))
            path.fill()
        }
    }

    func randDblPref(_ key:String) -> Double
    {
        let dbls = doublesPref(key)
        return randdblrng(dbls[0], high: dbls[1])
    }
    
    func randChoice(_ key:String) -> AnyObject
    {
        let values = Defaults.presetValueForKey(preset!, key: key) as! [Int]
        return values[randint(values.count)] as AnyObject
    }

    func doublePref(_ key:String) -> Double
    {
        return Defaults.presetValueForKey(preset!, key: key) as! Double
    }

    func doublesPref(_ key:String) -> [Double]
    {
        return Defaults.presetValueForKey(preset!, key: key) as! [Double]
    }
    
    func colorTypeName(_ colorType:ColorType) -> String  
    {
        switch colorType
        {
            case .random:    return "Random" 
            case .list:      return "List"
            case .direction: return "Direction"
            case .num:       return "???"
        }
    }
}
