
import ScreenSaver

class KrkklView : ScreenSaverView
{
    var numrows = 100
    var pos:     (x: Int, y: Int) = (0, 0)
    var next:    (x: Int, y: Int) = (0, 0)
    var center:  (x: Int, y: Int) = (0, 0)

    var lastPos:Int = 0
    var nextPos:Int = 0
    var reset: String = "center" // what happens when the screen border is touched: "wrap", "center" or "random"
    
    override init(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func startAnimation() {
        
        setup()
        super.startAnimation()
        setup()
        setAnimationTimeInterval(1.0 / 30.0)
        needsDisplay = true
    }
        
    override func hasConfigureSheet() -> Bool { return false }
    func width() -> Int { return Int(bounds.size.width) }
    func height() -> Int { return Int(bounds.size.height) }
    func randint(n: Int) -> Int { return Int(arc4random_uniform(UInt32(n)+1)) }
    
    func setup() {

        var numrows = 100
        numrows = min(numrows, height()/2)

        // start at centre
        let (cw, ch) = cubeSize()
        pos = (width()/cw/2 , numrows/2)
        
        next.x = Int(width()/cw)
        next.y = Int(height()/ch)
 
        center.x = Int(next.x/2)
        center.y = Int(next.y/2)
    }
    
    override func drawRect(rect: NSRect) 
    {
        super.drawRect(rect)
        var bPath:NSBezierPath = NSBezierPath(rect: bounds)
        NSColor.blackColor().set()
        bPath.fill()
    }
    
    override func animateOneFrame() 
    {
        let context = window!.graphicsContext
        NSGraphicsContext.setCurrentContext(context)
        drawNextCube()
        context?.flushGraphics()
    }
    
    func cubeSize() -> (w: Int, h: Int) 
    {
        let h = height()/numrows
        return (Int(sin(M_PI/3) * Double(h)), h)
    }
    
    func drawNextCube()
    {
        var skip = -1
        
        let (cw, ch) = cubeSize()

        let nx = width()/cw
        let ny = height()/ch

        nextPos = randint(5)
        lastPos = nextPos

        switch nextPos
        {
        case 0: // up
                pos.y += 1
            
        case 1: // right
                if (x%2)==1 { y -= 1 }
                x += 1

        case 2: // left
                if (x%2)==1 { y -= 1 }
                x -= 1

        case 3: // down
                pos.y -= 1
                skip = 0 // dont paint top

        case 4: // back left
                if (x%2)==0 { y += 1 }
                x -= 1
                skip = 2 // dont paint right

        case 5: // back right
                if (x%2)==0 { y += 1 }
                x += 1
                skip = 1 // dont paint left
            
        default:
                break
        }

        if (pos.x < 1 || pos.y < 2 || pos.x > nx-1 || pos.y > ny-1)  // if screen border is touched
        {
            if reset == "center" 
            {
                pos.x = center.x
                pos.y = center.y
            }
            else if reset == "random" 
            {
                pos.x = randint(next.x-1)
                pos.y = randint(next.y-1)
            }
            else if reset == "wrap" 
            {
                if (pos.x < 1) {
                    pos.x = next.x-1
                }   
                else if (pos.x > next.x-1)
                {   
                    pos.x = 1
                }
                if (pos.y < 2)
                {
                    pos.y = next.y-1
                }
                else if (pos.y > next.y-1)
                {
                    pos.y = 2
                }
            }
            lastPos = randint(5)
        }

        drawCube(color: NSColor.greenColor(), skip: skip)
    }
    
    func drawCube(#color: NSColor, skip: Int)
    {
        let (w, h) = cubeSize()
        
        let s = h/2
        let x = pos.x*w
        let y = (pos.x%2 == 0) ? (pos.y*h) : (pos.y*h - h/2)
     
        if skip != 0 { // top
            color.set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x   ,y: y))
            path.lineToPoint(NSPoint(x: x+w ,y: y+s))
            path.lineToPoint(NSPoint(x: x   ,y: y+h))
            path.lineToPoint(NSPoint(x: x-w ,y: y+s))
            path.fill()
        }
        if skip != 1 { // left
            color.darken(0.6).set()
            let path = NSBezierPath()
            path.moveToPoint(NSPoint(x: x    ,y: y))
            path.lineToPoint(NSPoint(x: x-w  ,y: y+s))
            path.lineToPoint(NSPoint(x: x-w  ,y: y-s))
            path.lineToPoint(NSPoint(x: x    ,y: y-h))
            path.fill()
        }
        if skip != 2 { // right
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
