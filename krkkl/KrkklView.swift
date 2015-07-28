
// http://www.raywenderlich.com/74438/swift-tutorial-a-quick-start
// http://stackoverflow.com/questions/27852616/do-swift-screensavers-work-in-mac-os-x-before-yosemite

import ScreenSaver

class KrkklView : ScreenSaverView {
    
    var canvasColor: NSColor = NSColor.blackColor()
    var circleColor: NSColor = NSColor.redColor()
    var frameCount = 0
    
    override init(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setAnimationTimeInterval(1.0 / 60.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }
    
    override func startAnimation() {
        super.startAnimation()
        needsDisplay = true
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func drawRect(rect: NSRect) {
        super.drawRect(rect)
        drawBackground()
     }
    
    override func animateOneFrame() {
        window!.disableFlushWindow()
        drawCircle(canvasColor, radiusPercent: CGFloat(15))
        let r = CGFloat(sin(Float(frameCount) / 30) * 2 + 11)
        drawCircle(circleColor, radiusPercent: r)
        frameCount += 1
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
    
}
    

