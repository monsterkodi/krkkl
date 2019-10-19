import Cocoa

class ListCell : NSView
{
    override func draw(_ rect:NSRect)
    {
        NSGraphicsContext.saveGraphicsState()

        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()

        let colorList = defaults().colorLists[index()]
        
        if colorList.count == 0
        {
            NSColor.gray.set()
            let r = NSBezierPath(rect:bounds)
            r.fill()

            let str = "random"
            let textStyle = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = NSTextAlignment.center

            str.draw(in: bounds, withAttributes: [NSParagraphStyleAttributeName: textStyle])
        }
        else if colorList.count == 1 && colorList.first!.hex() == "#000000"
        {
            NSColor.black.set()
            let r = NSBezierPath(rect:bounds)
            r.fill()

            let str = "direction"
            let textStyle = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = NSTextAlignment.center

            str.draw(in: bounds, withAttributes: [NSParagraphStyleAttributeName: textStyle, NSForegroundColorAttributeName: NSColor.white])
        }
        else
        {
            var colorIndex = 0
            for color in colorList
            {
                color.set()
                let num = CGFloat(colorList.count)
                let r = NSBezierPath(rect: NSRect(x:CGFloat(colorIndex)*bounds.width/num, y:0, width:bounds.width/num, height:bounds.height))
                r.fill()
                colorIndex += 1
            }
        }
        
        NSGraphicsContext.restoreGraphicsState()
    }
    
    func defaults() -> Defaults { return (window!.delegate as! SheetController).defaults }
    
    func table() -> TableView { return superview!.superview!.superview as! TableView }
    
    func index() -> Int
    {
        return table().row(for: self)
    }    
}
