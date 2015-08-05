import Cocoa

class ListCell : NSView
{
    override func drawRect(rect:NSRect)
    {
        NSGraphicsContext.saveGraphicsState()

        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()

        let colorList = defaults().colorLists[index()]
        
        if colorList.count == 0
        {
            NSColor.grayColor().set()
            let r = NSBezierPath(rect:bounds)
            r.fill()

            let str = "random"
            let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = NSTextAlignment.CenterTextAlignment

            str.drawInRect(bounds, withAttributes: [NSParagraphStyleAttributeName: textStyle])
        }
        else if colorList.count == 1 && colorList.first!.hex() == "#000"
        {
            NSColor.blackColor().set()
            let r = NSBezierPath(rect:bounds)
            r.fill()

            let str = "direction"
            let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = NSTextAlignment.CenterTextAlignment

            str.drawInRect(bounds, withAttributes: [NSParagraphStyleAttributeName: textStyle, NSForegroundColorAttributeName: NSColor.whiteColor()])
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
                colorIndex++
                println(colorIndex)
            }
        }
        
        NSGraphicsContext.restoreGraphicsState()
    }
    
    func defaults() -> Defaults { return (window!.delegate as! SheetController).defaults }
    
    func table() -> TableView { return superview!.superview!.superview as! TableView }
    
    func index() -> Int
    {
        return table().rowForView(self)
    }    
}
