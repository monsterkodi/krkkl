
import ScreenSaver

enum Side:Int {
    case UP = 0, RIGHT, LEFT, DOWN, BACKL, BACKR, NONE
}

enum ColorFade: Int {
    case RANDOM=0, LIST, DIRECTION, NUM
}

class KrkklView : ScreenSaverView
{
    var pos:     (x: Int, y: Int) = (0, 0)
    var size:    (x: Int, y: Int) = (0, 0)
    var center:  (x: Int, y: Int) = (0, 0)

    var lastDir:Int = 0
    var nextDir:Int = 0
    var keepDir:[Float] = [0,0,0,0,0,0]
    var reset:String = "center" // what happens when the screen border is touched: "wrap", "center" or "random"
    
    var animState:String = "anim"
    var fadeCount:Int = 0
    var cubeCount:Int = 0
    var maxCubes:Int = 5000

    var colorType = ColorFade.NUM
    var colorFade:Float = 0
    var colorInc:Float  = 0
    var colorIndex:Int = 0
    var colorList:[NSColor] = [
        NSColor(red:0.1, green:0.1, blue:0.1, alpha: 1),
        NSColor(red:1, green:0, blue:0, alpha: 1),
        NSColor(red:0.2, green:0.2, blue:0.2, alpha: 1),
        NSColor(red:1, green:0.5, blue:0, alpha: 1),
        NSColor(red:0.2, green:0.2, blue:0.2, alpha: 1),
    ]
    
    var thisColor  = NSColor(red:0, green:0, blue:0, alpha: 1)
    var nextColor  = NSColor(red:0, green:0, blue:0, alpha: 1)
    var resetColor = NSColor(red:0, green:0, blue:0, alpha: 1)
    var rgbColor   = NSColor(red:0, green:0, blue:0, alpha: 1)

    func setup() 
    {
        size.y = randint(60)+30 // number of cube rows, used to calculate cubeSize
        
        let (cw, ch) = cubeSize()
        size.x = width()/cw

        center.x = size.x/2
        center.y = size.y/2
        
        colorFade = 0
        colorIndex = 0
        colorInc = Float(10+randint(size.y/2))/Float(size.y)
        colorType = ColorFade(rawValue: randint(ColorFade.NUM.rawValue))!

        switch colorType
        {
        case .RANDOM:
            thisColor = NSColor(red:0, green:0, blue:0, alpha: 1)
            nextColor = randColor()
        case .DIRECTION:
            thisColor = NSColor(red:0, green:0, blue:0, alpha: 1)
        case .LIST:
            thisColor = colorList[0]
        default: break
        }
        
        reset = ["center", "wrap", "random"][randint(2)]
        pos = center // start at centre
        
        let lk:Float = 0.05
        let hk:Float = 0.9
        keepDir[0] = lk + randflt() * hk
        keepDir[1] = lk + randflt() * hk
        keepDir[2] = lk + randflt() * hk
        keepDir[3] = keepDir[0]
        keepDir[4] = keepDir[1]
        keepDir[5] = keepDir[2]

        println("size \(size)")
        println("reset \(reset)")
        println("keepDir \(keepDir)")
        println("rgbColor \(rgbColor)")
        println("colorInc \(colorInc)")
        println("colorType \(colorType.rawValue)")
        
        cubeCount = 0
    }
        
    override func startAnimation() 
    {    
        setup()
        super.startAnimation()
        setAnimationTimeInterval(1.0 / 60.0)
        needsDisplay = true
    }
        
    override func animateOneFrame() 
    {
        let context = window!.graphicsContext
        NSGraphicsContext.setCurrentContext(context)
        
        if animState == "fade"
        {
            fadeOut()
        }
        else
        {
            if cubeCount >= maxCubes
            {
                animState = "fade"
                fadeCount = 0
            }
            drawNextCube()
        }
        
        context?.flushGraphics()
    }
    
    func fadeOut()
    {
        if fadeCount >= 100
        {
            clear()
            setup()
            animState = "anim"
        }
        else
        {
            clear(color:NSColor(red: 0, green: 0, blue: 0, alpha: 0.025))
            fadeCount += 1
        }
    }

    func clear(color:NSColor = NSColor.blackColor())
    {
        color.set()
        drawRect(bounds)
    }
    
    override func drawRect(rect: NSRect)
    {
        var bPath:NSBezierPath = NSBezierPath(rect: rect)
        bPath.fill()
    }
    
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
            colorIndex = (colorIndex + 1) % colorList.count
            rgbColor = colorList[colorIndex]  
            
        case .DIRECTION:
            let ci = colorInc/10.0
            var r = Float(rgbColor.red())
            var g = Float(rgbColor.green())
            var b = Float(rgbColor.blue())
            let side:Side = Side(rawValue:nextDir)!
            switch side
            {
            case .UP:    b = clamp(b + ci, low:0.0, high:1.0)
            case .LEFT:  r = clamp(r + ci, low:0.0, high:1.0)
            case .RIGHT: g = clamp(g + ci, low:0.0, high:1.0)
            case .DOWN:  b = clamp(b - ci, low:0.0, high:1.0)
            case .BACKR: r = clamp(r - ci, low:0.0, high:1.0)
            case .BACKL: g = clamp(g - ci, low:0.0, high:1.0)
            default: break
            }
            rgbColor = colorRGB([r,g,b])

        default: break
        }
    }
        
    func cubeSize() -> (w: Int, h: Int) 
    {
        var h = height()/size.y
        if (h % 2 == 1) { h -= 1 }
        return (Int(sin(M_PI/3) * Double(h)), h)
    }
    
    func drawNextCube()
    {
        var skip = Side.NONE
        
        nextDir = (randflt() < keepDir[lastDir]) ? lastDir : randint(5)
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
                pos.x = randint(size.x-1)
                pos.y = randint(size.y-1)
            }
            else if reset == "wrap" 
            {
                if      (pos.x < 1)        { pos.x = size.x-1 }   
                else if (pos.x > size.x-1) { pos.x = 1 }
                if      (pos.y < 2)        { pos.y = size.y-1 }
                else if (pos.y > size.y-1) { pos.y = 2 }
            }
            skip = .NONE
            lastDir = randint(5)
        }

        chooseNextColor()
        drawCube(skip)
        
        cubeCount += 1
    }
    
    func drawCube(skip: Side)
    {
        let (w, h) = cubeSize()
        
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
    
    override init(frame: NSRect, isPreview: Bool) 
    {
        super.init(frame: frame, isPreview: isPreview)
    }
    
    required init?(coder aDecoder: NSCoder) 
    {
        super.init(coder: aDecoder)
    }
    
    override func hasConfigureSheet() -> Bool { return false }
    func width() -> Int { return Int(bounds.size.width) }
    func height() -> Int { return Int(bounds.size.height) }
    func randint(n: Int) -> Int { return Int(arc4random_uniform(UInt32(n)+1)) }
    func randflt() -> Float { return Float(arc4random()) / Float(UINT32_MAX) }
    func rest(v:Float) -> Float { return v-floor(v) }
    func clamp(v:Float, low:Float, high:Float) -> Float { return max(low, min(v, high)) }
    func colorRGB(rgb:[Float]) -> NSColor { return NSColor(red: CGFloat(rgb[0]), green:CGFloat(rgb[1]), blue:CGFloat(rgb[2]), alpha:1) }
    func randColor() -> NSColor { return colorRGB([randflt(), randflt(), randflt()]) }
}

extension NSColor {
    
    func red()   -> CGFloat { return redComponent   }
    func green() -> CGFloat { return greenComponent }
    func blue()  -> CGFloat { return blueComponent  }
    
    func darken(factor: Float) -> NSColor {
        let f = CGFloat(factor)
        return NSColor(red: red()*f, green: green()*f, blue: blue()*f, alpha: 1)
    }
    
    func fadeTo(color:NSColor, fade:Float) -> NSColor {
        let r = CGFloat(red()   * CGFloat(1.0-fade) + CGFloat(fade) * color.red())
        let g = CGFloat(green() * CGFloat(1.0-fade) + CGFloat(fade) * color.green())
        let b = CGFloat(blue()  * CGFloat(1.0-fade) + CGFloat(fade) * color.blue())
        return NSColor(red: r, green: g, blue: b, alpha: 1)
    }
}
