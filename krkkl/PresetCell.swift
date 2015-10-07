import Cocoa

class PresetsCell : NSView
{
    override func drawRect(rect:NSRect)
    {
        NSGraphicsContext.saveGraphicsState()
        
        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()

        NSColor.redColor().set()
        round.fill()
        
        NSGraphicsContext.restoreGraphicsState()
    }
    
    func defaults() -> Defaults { return (window!.delegate as! SheetController).defaults }
    
    func table() -> TableView { return superview!.superview!.superview as! TableView }
    
    func index() -> Int
    {
        return table().rowForView(self)
    }    
}
