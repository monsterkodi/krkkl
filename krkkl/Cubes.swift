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
    var view:KrkklView?
    var fps:Double = 60
    var cpf:Double = 60
    var cubeSize:(x: Int, y: Int) = (0, 0)
    var pos:     (x: Int, y: Int) = (0, 0)
    var size:    (x: Int, y: Int) = (0, 0)
    var center:  (x: Int, y: Int) = (0, 0)

    var lastDir:Int = 0
    var nextDir:Int = 0
    var keepDir:[Double] = [0,0,0]
    var reset:String = "" // what happens when the screen border is touched: "wrap", "ping", "center" or "random"
    
    var cubeCount:Int = 0
    var maxCubes:Int = 5000

    var colorType = ColorType.LIST
    var colorFade:Float = 0
    var colorInc:Float = 0
    var colorIndex:Int = 0
    var colorList:[NSColor] = []
    var colorLists:[[[Float]]] = [[
        [0.1, 0.1, 0.1],
        [0.2, 0.2, 0.2],
        [1.0, 0.0, 0.0],
        [1.0, 0.5, 0.0],
        [1.0, 0.7, 0.0],
        [1.0, 0.5, 0.0],
        [1.0, 0.0, 0.0],
        [0.2, 0.2, 0.2],
    ],[
        [0.1, 0.1, 0.1],
        [0.2, 0.2, 0.2],
        [0.0, 0.0, 0.5],
        [0.0, 0.0, 1.0],
        [0.5, 0.5, 1.0],
        [0.0, 0.0, 1.0],
        [0.0, 0.0, 0.5],
        [0.2, 0.2, 0.2],
    ],[
        [0.1, 0.1, 0.1],
        [1.0, 1.0, 1.0],
        [0.5, 0.5, 0.5],
        [1.0, 1.0, 1.0],
        [0.5, 0.5, 0.5],
        [0.2, 0.2, 0.2],
    ],[
        [0.1, 0.1, 0.1],
        [1.0, 0.0, 0.0],
        [0.1, 0.1, 0.1],
        [1.0, 1.0, 1.0],
        [0.1, 0.1, 0.1],
        [1.0, 0.0, 0.0],
    ],[
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 0.0, 1.0],
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 0.0, 1.0],
    ],[
        [0.1, 0.1, 0.1],
        [1.0, 0.0, 0.0],
        [0.1, 0.1, 0.1],
        [0.0, 1.0, 0.0],
        [0.1, 0.1, 0.1],
        [0.0, 0.0, 1.0],
    ]]

    var thisColor  = colorRGB([0,0,0])
    var nextColor  = colorRGB([0,0,0])
    var resetColor = colorRGB([0,0,0])
    var rgbColor   = colorRGB([0,0,0])

    func isDone() -> Bool { return cubeCount >= maxCubes }
    func nextStep()
    {
        for c in 0...Int(cpf)
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

    func setup() 
    {
        // _______________________ preferences?

        let rows = view!.sheetController.defaults.valueForKey("rows") as! [String: AnyObject]
        let rowsRange = rows["value"] as! [Double]
        
        let keep_up     = (view!.sheetController.defaults.valueForKey("keep_up"   )  as! [String: AnyObject])["value"] as! [Double]
        let keep_left   = (view!.sheetController.defaults.valueForKey("keep_left" )  as! [String: AnyObject])["value"] as! [Double]
        let keep_right  = (view!.sheetController.defaults.valueForKey("keep_right")  as! [String: AnyObject])["value"] as! [Double]
        let speed       = (view!.sheetController.defaults.valueForKey("speed")       as! [String: AnyObject])["value"] as! [Double]
        let cube_amount = (view!.sheetController.defaults.valueForKey("cube_amount") as! [String: AnyObject])["value"] as! [Double]

        size.y = Int(randdblrng(rowsRange[0], rowsRange[1]))
        cubeSize.y = view!.height()/size.y
        if (cubeSize.y % 2 == 1) { cubeSize.y -= 1 }
        cubeSize.y = max(2, cubeSize.y)
        size.y = view!.height()/cubeSize.y
        cubeSize.x = Int(sin(M_PI/3) * Double(cubeSize.y))
        size.x = view!.width()/cubeSize.x

        colorType = randflt() < Float(2)/Float(colorLists.count+2) ? (randflt()<0.5 ? .RANDOM : .DIRECTION) : .LIST

        colorInc = randflt()
        colorInc = 1 + colorInc * colorInc * colorInc * colorInc * 99
        maxCubes = (size.y * size.y)*Int(randdblrng(cube_amount[0], cube_amount[1]))
        reset = ["random", "ping", "wrap"][randint(3)]
        
        // _______________________ derivatives

        cpf = speed[0]
        fps = speed[1]

        center.x = size.x/2
        center.y = size.y/2
        pos = center // start at center

        colorFade = 0
        colorIndex = 0

        let colorListIndex = randint(colorLists.count)
        colorList = []
        for i in 0...colorLists[colorListIndex].count-1
        {
            colorList += [colorRGB(colorLists[colorListIndex][i])]
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
                
        keepDir[Side.UP.rawValue]    = randdblrng(keep_up[0], keep_up[1])
        keepDir[Side.LEFT.rawValue]  = randdblrng(keep_left[0], keep_left[1])
        keepDir[Side.RIGHT.rawValue] = randdblrng(keep_right[0], keep_right[1])

        cubeCount = 0
        
        println("")
        println("width \(view!.width())")
        println("height \(view!.height())")
        println("numx \(size.x)")
        println("numy \(size.y)")
        println("cube  \(cubeSize.x) \(cubeSize.y)")
        println("maxCubes \(maxCubes)")
        println("fps \(fps)")
        println("keepDir \(keepDir)")
        println("colorInc \(colorInc)")
        println("colorList \(colorListIndex)")
        println("colorType \(colorTypeName(colorType))")
        println("reset \(reset)")
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
            case .UP:    b = clamp(b + ci, 0.0, 1.0)
            case .LEFT:  r = clamp(r + ci, 0.0, 1.0)
            case .RIGHT: g = clamp(g + ci, 0.0, 1.0)
            case .DOWN:  b = clamp(b - ci, 0.0, 1.0)
            case .BACKR: r = clamp(r - ci, 0.0, 1.0)
            case .BACKL: g = clamp(g - ci, 0.0, 1.0)
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
        
        nextDir = (randdbl() < keepDir[lastDir%3]) ? lastDir : randint(6)
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
            
            if colorType == ColorType.DIRECTION && find(["center", "random"], reset) != nil {
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
            rgbColor.set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x   ,y: y))
            path.lineToPoint(NSPoint(x: x+w ,y: y+s))
            path.lineToPoint(NSPoint(x: x   ,y: y+h))
            path.lineToPoint(NSPoint(x: x-w ,y: y+s))
            path.fill()
        }
        
        if skip != .LEFT
        {
            rgbColor.darken(0.6).set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x    ,y: y))
            path.lineToPoint(NSPoint(x: x-w  ,y: y+s))
            path.lineToPoint(NSPoint(x: x-w  ,y: y-s))
            path.lineToPoint(NSPoint(x: x    ,y: y-h))
            path.fill()
        }
        
        if skip != .RIGHT
        {
            rgbColor.darken(0.25).set()
            var path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x    ,y: y))
            path.lineToPoint(NSPoint(x: x+w  ,y: y+s))
            path.lineToPoint(NSPoint(x: x+w  ,y: y-s))
            path.lineToPoint(NSPoint(x: x    ,y: y-h))
            path.fill()
        }
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
