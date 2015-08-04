import Cocoa

class ColorCell : NSColorWell
{
    init(color:NSColor)
    {
        super.init(frame:NSRect())
        self.color = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect)
    {
        super.drawRect(dirtyRect)
    }
}
