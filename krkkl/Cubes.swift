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
    var cubeSize:(x: Int, y: Int) = (0, 0)
    var pos:     (x: Int, y: Int) = (0, 0)
    var size:    (x: Int, y: Int) = (0, 0)
    var center:  (x: Int, y: Int) = (0, 0)

    var lastDir:Int = 0
    var nextDir:Int = 0
    var keepDir:[Float] = [0,0,0]
    var keepLow:Float = 0.1
    var keepHigh:Float = 0.9
    var reset:String = "center" // what happens when the screen border is touched: "wrap", "center" or "random"
    
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
    func nextStep() { drawNextCube() }

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

        size.y = randint(60)+20 // number of cube rows
        cubeSize.y = view!.height()/size.y
        if (cubeSize.y % 2 == 1) { cubeSize.y -= 1 }
        cubeSize.y = max(2, cubeSize.y)
        size.y = view!.height()/cubeSize.y
        cubeSize.x = Int(sin(M_PI/3) * Double(cubeSize.y))
        size.x = view!.width()/cubeSize.x

        colorType = randflt() < Float(2)/Float(colorLists.count+2) ? (randflt()<0.5 ? .RANDOM : .DIRECTION) : .LIST

        colorInc = randflt()
        colorInc = 1 + colorInc * colorInc * colorInc * colorInc * 99
        maxCubes = (size.y * size.y)+randint(size.y * size.y)
        reset = ["center", "wrap", "random"][randint(3)]
        keepLow = 0.2
        keepHigh = 0.96

        // _______________________ derivatives

        fps = 10+randdbl()*Double(size.y)

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
                
        keepDir[0] = randfltrng(keepLow, keepHigh)
        keepDir[1] = randfltrng(keepLow, keepHigh)
        keepDir[2] = randfltrng(keepLow, keepHigh)

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
        
        nextDir = (randflt() < keepDir[lastDir%3]) ? lastDir : randint(6)
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
            skip = .NONE
            lastDir = randint(6)
            
            if colorType == .DIRECTION {
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
