
import ScreenSaver

enum Side:Int {
    case UP = 0, RIGHT, LEFT, DOWN, BACKR, BACKL, NONE
}

class KrkklView : ScreenSaverView
{
    var pos:     (x: Int, y: Int) = (0, 0)
    var size:    (x: Int, y: Int) = (0, 0)
    var center:  (x: Int, y: Int) = (0, 0)

    var lastPos:Int = 0
    var nextPos:Int = 0
    var reset:String = "center" // what happens when the screen border is touched: "wrap", "center" or "random"
    var keepdir:[Float] = [0,0,0,0,0,0,0]
    
    var animState:String = "anim"
    var fadeCount:Int = 0
    var cubeCount:Int = 0
    var maxCubes:Int = 1000
    
    override init(frame: NSRect, isPreview: Bool) 
    {
        super.init(frame: frame, isPreview: isPreview)
    }
    
    required init?(coder aDecoder: NSCoder) 
    {
        super.init(coder: aDecoder)
    }
    
    override func startAnimation() 
    {    
        setup()
        super.startAnimation()
        setAnimationTimeInterval(1.0 / 60.0)
        needsDisplay = true
    }
        
    override func hasConfigureSheet() -> Bool { return false }
    func width() -> Int { return Int(bounds.size.width) }
    func height() -> Int { return Int(bounds.size.height) }
    func randint(n: Int) -> Int { return Int(arc4random_uniform(UInt32(n)+1)) }
    func randflt() -> Float { return Float(arc4random()) / Float(UINT32_MAX) }
    
    func setup() 
    {
        size.y = randint(60)+30 // number of cube rows, used to calculate cubeSize
        
        let (cw, ch) = cubeSize()
        size.x = width()/cw

        center.x = size.x/2
        center.y = size.y/2

        pos = center // start at centre
                        
        keepdir[0] = 0.1 + randflt() * 0.8
        keepdir[1] = 0.1 + randflt() * 0.8
        keepdir[2] = 0.1 + randflt() * 0.8
        keepdir[3] = keepdir[0]
        keepdir[4] = keepdir[1]
        keepdir[5] = keepdir[2]         

        cubeCount = 0
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
            clear(color:NSColor(red: 0, green: 0, blue: 0, alpha: 0.02))
            fadeCount += 1
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
        
        nextPos = (randflt() < keepdir[lastPos]) ? lastPos : randint(5)
        lastPos = nextPos
        
        let side:Side = Side(rawValue:nextPos)!
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
            lastPos = randint(5)
        }

        drawCube(color: NSColor.greenColor(), skip: skip)
        
        cubeCount += 1
    }
    
    func drawCube(#color: NSColor, skip: Side)
    {
        let (w, h) = cubeSize()
        
        let s = h/2
        let x = pos.x*w
        let y = (pos.x%2 == 0) ? (pos.y*h) : (pos.y*h - s)
     
        if skip != .UP
        {
            color.set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x   ,y: y))
            path.lineToPoint(NSPoint(x: x+w ,y: y+s))
            path.lineToPoint(NSPoint(x: x   ,y: y+h))
            path.lineToPoint(NSPoint(x: x-w ,y: y+s))
            path.fill()
        }
        
        if skip != .LEFT
        {
            color.darken(0.6).set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x    ,y: y))
            path.lineToPoint(NSPoint(x: x-w  ,y: y+s))
            path.lineToPoint(NSPoint(x: x-w  ,y: y-s))
            path.lineToPoint(NSPoint(x: x    ,y: y-h))
            path.fill()
        }
        
        if skip != .RIGHT
        {
            color.darken(0.25).set()
            var path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x    ,y: y))
            path.lineToPoint(NSPoint(x: x+w  ,y: y+s))
            path.lineToPoint(NSPoint(x: x+w  ,y: y-s))
            path.lineToPoint(NSPoint(x: x    ,y: y-h))
            path.fill()
        }
    }
}

extension NSColor {
    
    func red()   -> CGFloat { return redComponent   }
    func green() -> CGFloat { return greenComponent }
    func blue()  -> CGFloat { return blueComponent  }
    
    func darken(factor: Float) -> NSColor {
        let f = CGFloat(factor)
        return NSColor(red: red()*f, green: green()*f, blue: blue()*f, alpha: 1)
    }
}
