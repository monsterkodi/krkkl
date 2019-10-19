
import Cocoa

class TableView : NSTableView
{
    var delAction:Selector?
    var addAction:Selector?
    
    func selectRow(_ row:Int)
    {
        selectRowIndexes(IndexSet(integer:row), byExtendingSelection:false)
    }
    
    func insertRow(_ row:Int)
    {
        self.insertRows(at: IndexSet(integer:row), withAnimation: NSTableView.AnimationOptions.slideLeft)
    }
    
    func insertRows(_ num:Int)
    {
        let indexes = IndexSet(integersIn: 0..<num)
        self.insertRows(at: indexes, withAnimation: NSTableView.AnimationOptions())
    }
    
    func removeRow(_ row:Int)
    {
        removeRows(at: IndexSet(integer:row), withAnimation: NSTableView.AnimationOptions.slideRight)
    }
    
    func clear()
    {
        removeRows(at: IndexSet(integersIn: 0..<numberOfRows), withAnimation: NSTableView.AnimationOptions())
    }
    
    override func keyDown(with event: NSEvent)
    {
        Swift.print("onKey \(event)")
        
        switch event.keyCode
        {
        case 117:
            if delAction != nil
            {
                delegate?.perform(delAction!, with:self)
            }
        case 45:
            if event.modifierFlags.contains(NSEvent.ModifierFlags.command)
            {
                if addAction != nil
                {
                    delegate?.perform(addAction!)
                }
            }
        default:
            super.keyDown(with: event)
        }
    }
}

class TableRow : NSTableRowView
{
    override func draw(_ dirtyRect: NSRect)
    {
        if isSelected
        {
            NSGraphicsContext.saveGraphicsState()
            
            NSColor.black.set()
            NSBezierPath(roundedRect: NSRect(x:1, y:0, width:bounds.width-3, height:bounds.height-1), xRadius:8, yRadius:8).fill()

            NSGraphicsContext.restoreGraphicsState()
        }
    }
}

class ColorsTableRow : NSTableRowView
{
    override func draw(_ dirtyRect: NSRect)
    {
        (subviews.first as! ColorCell).setSelected(isSelected)
    }
}
