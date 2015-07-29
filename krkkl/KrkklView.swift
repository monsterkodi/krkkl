
import ScreenSaver

class KrkklView : ScreenSaverView {
    
    var numrows = 100
    
    var pos: (x: Int, y: Int) = (0, 0)
    
    var lastPos: UInt = 0
    var nextPos: UInt = 0
    
    override init(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }

    override func startAnimation() {
        super.startAnimation()
        setup()
        setAnimationTimeInterval(1.0 / 30.0)
        needsDisplay = true
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    func setup() {
        numrows = min(numrows, Int(bounds.size.height)/2)
        // start at centre
        let (cw, ch) = cubeSize()
        pos = (Int(bounds.size.width)/cw/2 , numrows/2)
    }
    
    override func drawRect(rect: NSRect) {
        super.drawRect(rect)
        var bPath:NSBezierPath = NSBezierPath(rect: bounds)
        NSColor.blackColor().set()
        bPath.fill()
    }
    
    override func animateOneFrame() {
        let context = window!.graphicsContext
        NSGraphicsContext.setCurrentContext(context)
        drawNextCube()
        context?.flushGraphics()
    }
    
    func cubeSize() -> (w: Int, h: Int) {
        let height = Int(bounds.size.height)/numrows
        return (Int(sin(M_PI/3) * Double(height)), height)
    }
    
    func drawNextCube()
    {
        var skip = -1
        
        let (cw, ch) = cubeSize()

        let nx = Int(bounds.size.width)/cw
        let ny = Int(bounds.size.height)/ch

        nextPos = UInt(arc4random_uniform(6))
        lastPos = nextPos

        switch nextPos
        {
        case 0: // up
                pos.y += 1
            
        case 1: // right
                if (pos.x%2)==1 {
                    pos.y -= 1
                }
                pos.x += 1

        case 2: // left
                if (pos.x%2)==1 {
                    pos.y -= 1
                }
                pos.x -= 1

        case 3: // down
                pos.y -= 1
                skip = 0 // dont paint top

        case 4: // back left
                if (pos.x%2)==0 {
                    pos.y += 1
                }
                pos.x -= 1
                skip = 2 // dont paint right

        case 5: // back right
                if (pos.x%2)==0 {
                    pos.y += 1
                }
                pos.x += 1
                skip = 1 // dont paint left
            
            default:
                break
        }

        if (pos.x < 1 || pos.y < 2 || pos.x > nx-1 || pos.y > ny-1) {
//            if reset == "center" {
//                x = cx
//                y = cy
//            }
//            elif reset == "random" {
//                x = randint(0,nx-1)
//                y = randint(0,ny-1)
//            }
//            else if reset == "wrap" {
            if (true) {
                if (pos.x < 1) {
                    pos.x = nx-1
                }   
                else if (pos.x > nx-1)
                {   
                    pos.x = 1
                }
                if (pos.y < 2)
                {
                    pos.y = ny-1
                }
                else if (pos.y > ny-1)
                {
                    pos.y = 2
                }
            }
            lastPos = UInt(arc4random_uniform(6))
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
    
    func darken(factor: Float) -> NSColor {
        let f = CGFloat(factor)
        let red = redComponent
        let green = greenComponent
        let blue = blueComponent
        return NSColor(red: red*f, green: green*f, blue: blue*f, alpha: 1)
    }

}


