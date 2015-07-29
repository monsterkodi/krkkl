
import ScreenSaver

class KrkklView : ScreenSaverView
{
    var numrows = 10
    var pos:     (x: Int, y: Int) = (0, 0)
    var size:    (x: Int, y: Int) = (0, 0)
    var center:  (x: Int, y: Int) = (0, 0)

    var lastPos:Int = 0
    var nextPos:Int = 0
    var reset:String = "random" // what happens when the screen border is touched: "wrap", "center" or "random"
    var keepdir:[Float] = [0,0,0,0,0,0,0]
    
    var animState:String = "anim"
    var fadeCount:Int = 0
    var cubeCount:Int = 0
    var maxCubes:Int = 100
    
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
        cubeCount = 0
        numrows = randint(30)+10
        
        // start at centre
        let (cw, ch) = cubeSize()
        pos = (width()/cw/2 , numrows/2)

        size.x = width()/cw
        size.y = height()/ch
        
        center.x = size.x/2
        center.y = size.y/2
                
        keepdir[0] = 0.1 + randflt() * 0.8
        keepdir[1] = 0.1 + randflt() * 0.8
        keepdir[2] = 0.1 + randflt() * 0.8
        keepdir[3] = keepdir[0]
        keepdir[4] = keepdir[1]
        keepdir[5] = keepdir[2]         
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
                debugPrint(animState)
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
        var h = height()/numrows
        if (h % 2 == 1) { h -= 1 }
        return (Int(sin(M_PI/3) * Double(h)), h)
    }
    
    func drawNextCube()
    {
        var skip = -1
        
        let (cw, ch) = cubeSize()

        let nx = width()/cw
        let ny = height()/ch

        nextPos = (randflt() < keepdir[lastPos]) ? lastPos : randint(5)
        lastPos = nextPos

        switch nextPos
        {
        case 0: // up
                pos.y += 1
            
        case 1: // right
                if (pos.x%2)==1 { pos.y -= 1 }
                pos.x += 1

        case 2: // left
                if (pos.x%2)==1 { pos.y -= 1 }
                pos.x -= 1

        case 3: // down
                pos.y -= 1
                if cubeCount > 0 { skip = 0 } // dont paint top

        case 4: // back left
                if (pos.x%2)==0 { pos.y += 1 }
                pos.x -= 1
                if cubeCount > 0 { skip = 2 } // dont paint right

        case 5: // back right
                if (pos.x%2)==0 { pos.y += 1 }
                pos.x += 1
                if cubeCount > 0 { skip = 1 } // dont paint left
            
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
            skip = -1
            lastPos = randint(5)
        }

        drawCube(color: NSColor.greenColor(), skip: skip)
        
        cubeCount += 1
    }
    
    func drawCube(#color: NSColor, skip: Int)
    {
        let (w, h) = cubeSize()
        
        let s = h/2
        let x = pos.x*w
        let y = (pos.x%2 == 0) ? (pos.y*h) : (pos.y*h - s)
     
        if skip != 0  // top
        {
            color.set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x   ,y: y))
            path.lineToPoint(NSPoint(x: x+w ,y: y+s))
            path.lineToPoint(NSPoint(x: x   ,y: y+h))
            path.lineToPoint(NSPoint(x: x-w ,y: y+s))
            path.fill()
        }
        
        if skip != 1 // left
        {
            color.darken(0.6).set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x    ,y: y))
            path.lineToPoint(NSPoint(x: x-w  ,y: y+s))
            path.lineToPoint(NSPoint(x: x-w  ,y: y-s))
            path.lineToPoint(NSPoint(x: x    ,y: y-h))
            path.fill()
        }
        
        if skip != 2  // right
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
