
// http://www.raywenderlich.com/74438/swift-tutorial-a-quick-start
// http://stackoverflow.com/questions/27852616/do-swift-screensavers-work-in-mac-os-x-before-yosemite

import ScreenSaver

class KrkklView : ScreenSaverView {
    
    var canvasColor: NSColor = NSColor.blackColor()
    var circleColor: NSColor = NSColor.redColor()
    var frameCount = 0
    var sizex = 0
    var sizey = 0
    
    override init(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }

    func setup() {
        var numrows = 10
        var height = Int(bounds.size.height)
        numrows = min(numrows, height/2)
        sizey = height/numrows
        sizex = Int(sin(M_PI/3) * Double(sizey))
    }
    
    override func startAnimation() {
        setup()
        super.startAnimation()
        setAnimationTimeInterval(1.0 / 60.0)
        needsDisplay = true
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func animateOneFrame() {
        needsDisplay = true
        frameCount += 1
    }
    
    override func drawRect(rect: NSRect) {
        super.drawRect(rect)
        window!.disableFlushWindow()
        drawBackground()
        drawCircle(canvasColor, radiusPercent: CGFloat(15))
        let r = CGFloat(sin(Float(frameCount) / 30) * 2 + 11)
        drawCircle(circleColor, radiusPercent: r)
        drawCube(xi: 10, yi: 10, color: NSColor.greenColor())
        window!.enableFlushWindow()
    }
    
    func drawBackground() {
        var bPath:NSBezierPath = NSBezierPath(rect: bounds)
        canvasColor.set()
        bPath.fill()
    }

    func drawCircle(color: NSColor, radiusPercent: CGFloat) {
        let radius = bounds.size.height * radiusPercent/100
        var circleRect = NSMakeRect(bounds.size.width/2 - radius/2, bounds.size.height/2 - radius/2, radius, radius)
        var cPath: NSBezierPath = NSBezierPath(ovalInRect: circleRect)
        color.set()
        cPath.fill()
    }
    
    func drawCube(#xi: Int, yi: Int, color: NSColor)
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
        
//        if (skip != 0):
        color.set() // top
        var path = NSBezierPath()
        path.moveToPoint(NSPoint(x: x   ,y: y))
        path.lineToPoint(NSPoint(x: x+w ,y: y+s))
        path.lineToPoint(NSPoint(x: x   ,y: y+h))
        path.lineToPoint(NSPoint(x: x-w ,y: y+s))
        path.fill()
        
//        if skip != 1:
        darkenColor(color, factor: 0.6).set()
        path = NSBezierPath()
        path.moveToPoint(NSPoint(x: x    ,y: y))
        path.lineToPoint(NSPoint(x: x-w  ,y: y+s))
        path.lineToPoint(NSPoint(x: x-w  ,y: y-s))
        path.lineToPoint(NSPoint(x: x    ,y: y-h))
        path.fill()
        
//        if skip != 2:
        darkenColor(color, factor: 0.25).set()
        path = NSBezierPath()
        path.moveToPoint(NSPoint(x: x    ,y: y))
        path.lineToPoint(NSPoint(x: x+w  ,y: y+s))
        path.lineToPoint(NSPoint(x: x+w  ,y: y-s))
        path.lineToPoint(NSPoint(x: x    ,y: y-h))
        path.fill()
    }

    
    func darkenColor(color: NSColor, factor: Float) -> NSColor {
        let f = CGFloat(factor)
        let red = color.redComponent
        let green = color.greenComponent
        let blue = color.blueComponent
        return NSColor(red: red*f, green: green*f, blue: blue*f, alpha: 1)
    }
    
}


