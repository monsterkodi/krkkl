
import Cocoa

class TableView : NSTableView
{
}

class TableRow : NSTableRowView
{
    override func drawRect(dirtyRect: NSRect)
    {
        if selected
        {
            NSGraphicsContext.saveGraphicsState()
            
            colorRGB([0.5,0.5,0.5]).set()
            NSBezierPath(roundedRect: NSRect(x:1, y:0, width:bounds.width-3, height:bounds.height-1), xRadius:8, yRadius:8).fill()

            NSGraphicsContext.restoreGraphicsState()
        }
    }
}
