import Cocoa

class SheetController : NSWindowController, NSTableViewDelegate
{
    var defaults = Defaults()
    
    @IBOutlet var colorsPage: NSView?
    @IBOutlet var valuesView: NSTableView?
    @IBOutlet var pages:      NSTabView?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        valuesView!.setDelegate(self)
        let indexes = NSIndexSet(indexesInRange: NSRange(location:0,length:defaults.defaultValues.count))
        valuesView!.insertRowsAtIndexes(indexes, withAnimation: NSTableViewAnimationOptions.EffectNone)
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        if tableColumn?.identifier == "label"
        {
            var label = NSTextView(frame: NSMakeRect(0,0,200,10))
            label.string = defaults.defaultValues[row]["label"] as? String
            label.drawsBackground = false
            label.editable = false
            label.selectable = false
            return label
        }
        else if tableColumn?.identifier == "value"
        {
            var label = NSTextView(frame: NSMakeRect(0,0,200,10))
            var value = "value" // defaults.defaultValues[row]["value"]
            label.string = "\(value)"
            label.drawsBackground = false
            label.editable = true
            label.fieldEditor = true
            return label
        }
        return nil
    }
    
    @IBAction func showPage(sender: AnyObject)
    {
        pages?.selectTabViewItemAtIndex(sender.selectedSegment)
    }
    
    @IBAction func updateDefaults(sender: AnyObject)
    {
        println("updateDefaults")
    }
   
    @IBAction func closeConfigureSheet(sender: AnyObject)
    {
        NSApp.endSheet(window!)
    }
    
    override var windowNibName: String!
    {
        return "ConfigureSheet"
    }
}
