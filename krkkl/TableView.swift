
import Cocoa

class TableView : NSTableView
{
    func selectRow(row:Int)
    {
        selectRowIndexes(NSIndexSet(index:row), byExtendingSelection:false)
    }
    
    func insertRow(row:Int)
    {
        insertRowsAtIndexes(NSIndexSet(index:row), withAnimation: NSTableViewAnimationOptions.SlideLeft)
    }
    
    func insertRows(num:Int)
    {
        let indexes = NSIndexSet(indexesInRange: NSRange(location:0,length:num))
        insertRowsAtIndexes(indexes, withAnimation: NSTableViewAnimationOptions.EffectNone)
    }
    
    func removeRow(row:Int)
    {
        removeRowsAtIndexes(NSIndexSet(index:row), withAnimation: NSTableViewAnimationOptions.SlideRight)
    }
    
    func clear()
    {
        removeRowsAtIndexes(NSIndexSet(indexesInRange:NSRange(location: 0,length: numberOfRows)), withAnimation: NSTableViewAnimationOptions.EffectNone)
    }
}

class TableRow : NSTableRowView
{
    override func drawRect(dirtyRect: NSRect)
    {
        if selected
        {
            NSGraphicsContext.saveGraphicsState()
            
            NSColor.blackColor().set()
            NSBezierPath(roundedRect: NSRect(x:1, y:0, width:bounds.width-3, height:bounds.height-1), xRadius:8, yRadius:8).fill()

            NSGraphicsContext.restoreGraphicsState()
        }
    }
}

class ColorsTableRow : NSTableRowView
{
    override func drawRect(dirtyRect: NSRect)
    {
        (subviews.first as! ColorCell).setSelected(selected)
    }
}
