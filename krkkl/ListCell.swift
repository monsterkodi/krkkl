import Cocoa

class ListCell : NSView
{
    init()
    {
        super.init(frame:NSRect(x:0,y:0,width:50,height:50))
    }

    func initConstraints()
    {
        superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[cell(==50)]-|", options:nil, metrics:nil, views: ["cell" : self]))
        superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cell(==20)]", options:nil, metrics:nil, views: ["cell" : self]))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect:NSRect)
    {
        super.drawRect(rect)
        NSGraphicsContext.saveGraphicsState()

        NSColor.redColor().set()
        NSRectFill(rect)
        
        NSGraphicsContext.restoreGraphicsState()
    }
}
