import Cocoa

class ColorCell : NSColorWell
{
    var doActivate = false
    
    init(color:NSColor)
    {
        super.init(frame:NSRect())
        self.color = color
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect)
    {
        NSGraphicsContext.saveGraphicsState()
        
        color.set()
        
        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()
        
        let rect = NSBezierPath(rect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height))
        rect.fill()

        let shadow = NSShadow()
        shadow.set()

        NSGraphicsContext.restoreGraphicsState()
    }
    
    func table() -> TableView { return superview!.superview as! TableView }
    
    func index() -> Int
    {
        return table().rowForView(self)
    }
    
    override func mouseDown(theEvent: NSEvent)
    {
        doActivate = true
    }

    override func mouseDragged(theEvent: NSEvent)
    {
        super.mouseDown(theEvent)
        super.mouseDragged(theEvent)
        doActivate = false
    }

    override func mouseUp(theEvent: NSEvent)
    {
        if doActivate
        {
            activate(true)
            doActivate = false
            
            table().selectRow(index())
        }
    }
}
