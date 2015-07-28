
import ScreenSaver

class KrkklView : ScreenSaverView {
    
    var sizex = 0
    var sizey = 0
    var x = 0
    var y = 0
    var lastPos:UInt = 0
    var nextPos:UInt = 0
    
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
        setup()
        super.startAnimation()
        setAnimationTimeInterval(1.0 / 30.0)
        needsDisplay = true
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    func setup() {
        var numrows = 100
        var height = Int(bounds.size.height)
        numrows = min(numrows, height/2)
        sizey = height/numrows
        sizex = Int(sin(M_PI/3) * Double(sizey))
    }
    
    override func drawRect(rect: NSRect) {
        super.drawRect(rect)
        var bPath:NSBezierPath = NSBezierPath(rect: bounds)
        NSColor.blackColor().set()
        bPath.fill()
    }
    
    
    override func animateOneFrame() {
//        needsDisplay = true
//        setNeedsDisplayInRect(bounds)
        let context = window!.graphicsContext
        NSGraphicsContext.setCurrentContext(context)
        nextCube()
        context?.flushGraphics()
    }
    
    func nextCube()
    {
        var skip = -1
        var width = Int(bounds.size.width)
        var height = Int(bounds.size.height)

        var nx = Int(width/sizex)
        var ny = Int(height/sizey)

        nextPos = UInt(arc4random_uniform(6))
        lastPos = nextPos

        switch nextPos
        {
        case 0: // up
                y += 1
            
        case 1: // right
                if (x%2)==1 {
                    y -= 1
                }
                x += 1

        case 2: // left
                if (x%2)==1 {
                    y -= 1
                }
                x -= 1

        case 3: // down
                y -= 1
                skip = 0 // dont paint top

        case 4: // back left
                if (x%2)==0 {
                    y += 1
                }
                x -= 1
                skip = 2 // dont paint right

        case 5: // back right
                if (x%2)==0 {
                    y += 1
                }
                x += 1
                skip = 1 // dont paint left
            
            default:
                break
        }

        if (x < 1 || y < 2 || x > nx-1 || y > ny-1) {
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
                if (x < 1) {
                    x = nx-1
                }   
                else if (x > nx-1)
                {   
                    x = 1
                }
                if (y < 2)
                {
                    y = ny-1
                }
                else if (y > ny-1)
                {
                    y = 2
                }
            }
            lastPos = UInt(arc4random_uniform(6))
        }

        drawCube(xi: x, yi: y, color: NSColor.greenColor(), skip: skip)
    }
    
    func drawCube(#xi: Int, yi: Int, color: NSColor, skip: Int)
    {
        let h = sizey
        let w = sizex
        let s = h/2
        
        let x = xi * w
        var y = yi * h
        
        if (xi%2 == 1)
        {
            y -= h/2
        }
        
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


