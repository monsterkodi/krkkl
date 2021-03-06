import Cocoa

class ColorCell : NSColorWell
{
    var doActivate = false
    var isSelected = false
    static var isActive = false
    
    init(color:NSColor)
    {
        super.init(frame:NSRect())
        self.color = color
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelected(_ selected:Bool)
    {
        isSelected = selected
        needsDisplay = true
        if ColorCell.isActive && selected
        {
            activate(true)
        }
    }
    
    override func draw(_ dirtyRect: NSRect)
    {
        NSGraphicsContext.saveGraphicsState()
        
        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()

        let rect = NSBezierPath(rect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height))
        color.set()
        rect.fill()

        if isSelected
        {
            colorRGB([1-color.r(), 1-color.g(), 1-color.b()]).set()
            let rect = NSBezierPath(ovalIn: NSRect(x:8,y:8,width:bounds.height-16, height:bounds.height-16))
            rect.fill()
        }

        NSGraphicsContext.restoreGraphicsState()
    }
    
    func table() -> TableView { return superview!.superview as! TableView }
    
    func rgb() -> NSColor { return color.usingColorSpace(NSColorSpace.deviceRGB)! }
    
    func index() -> Int
    {
        return table().row(for: self)
    }
    
    override func mouseDown(with theEvent: NSEvent)
    {
        doActivate = true
    }

    override func mouseDragged(with theEvent: NSEvent)
    {
        super.mouseDown(with: theEvent)
        super.mouseDragged(with: theEvent)
        doActivate = false
    }

    override func mouseUp(with theEvent: NSEvent)
    {
        if doActivate
        {
            activate(true)
            doActivate = false
            ColorCell.isActive = true
            table().becomeFirstResponder()
            table().selectRow(index())
        }
    }
}
