import Cocoa

class ListCell : NSView
{
    override func drawRect(rect:NSRect)
    {
        NSGraphicsContext.saveGraphicsState()

        NSColor.grayColor().set()
        
        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()
        
        let red = NSBezierPath(rect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height))
        red.fill()
        
        NSGraphicsContext.restoreGraphicsState()
    }
}
