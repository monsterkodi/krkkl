import Cocoa

class SheetController : NSWindowController, NSTableViewDelegate
{
    var defaults = Defaults()
    
    @IBOutlet var colorsPage: NSView?
    @IBOutlet var valuesView: NSTableView?
    @IBOutlet var pages:      NSTabView?
    @IBOutlet var rangeBox:   NSBox?

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
            var clone = rangeBox!.clone()
            var box = clone.subviews.first! as! NSView
            box.identifier = defaults.defaultValues[row]["key"] as? String
            
            var minSlider = box.childWithIdentifier("minSlider") as! NSSlider
            var maxSlider = box.childWithIdentifier("maxSlider") as! NSSlider
            var minText   = box.childWithIdentifier("minText") as! NSTextField
            var maxText   = box.childWithIdentifier("maxText") as! NSTextField
            
            let minRange = (defaults.defaultValues[row]["range"] as! [Double]).first! as Double
            let maxRange = (defaults.defaultValues[row]["range"] as! [Double]).last! as Double
            let minValue = (defaults.defaultValues[row]["value"] as! [Double]).first! as Double
            let maxValue = (defaults.defaultValues[row]["value"] as! [Double]).last! as Double
            
            minText.doubleValue = minValue
            minSlider.minValue = minRange
            minSlider.maxValue = maxRange
            minSlider.doubleValue = minValue
            minSlider.target = self
            minSlider.action = Selector("sliderChanged:")
            
            maxText.doubleValue = maxValue
            maxSlider.minValue = minRange
            maxSlider.maxValue = maxRange
            maxSlider.doubleValue = maxValue
            maxSlider.target = self
            maxSlider.action = Selector("sliderChanged:")
            
            return clone
        }
        return nil
    }
    
    @IBAction func sliderChanged(sender: AnyObject)
    {
        let slider = sender as! NSSlider
        let box    = slider.superview!
        let row    = rowForKey(box.identifier!)
        let step   = defaults.defaultValues[row]["step"] as! Double
        let value  = valueStep(slider.doubleValue, step)

        var text = box.childWithIdentifier(slider.identifier == "minSlider" ? "minText" : "maxText") as! NSTextField
        text.doubleValue = value
        
        if slider.identifier == "minSlider"
        {
            let otherSlider = box.childWithIdentifier("maxSlider") as! NSSlider
            let otherText   = box.childWithIdentifier("maxText") as! NSTextField
            otherSlider.doubleValue = max(otherSlider.doubleValue, slider.doubleValue)
            otherText.doubleValue = max(otherText.doubleValue, value)
        }
        else
        {
            let otherSlider = box.childWithIdentifier("minSlider") as! NSSlider
            let otherText   = box.childWithIdentifier("minText") as! NSTextField
            otherSlider.doubleValue = min(otherSlider.doubleValue, slider.doubleValue)
            otherText.doubleValue = min(otherText.doubleValue, value)
        }
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
    
    func rowForKey(key:String) -> Int
    {
        for index in 0...defaults.defaultValues.count
        {
            if (defaults.defaultValues[index]["key"] as! String) == key
            {
                return index
            }
        }
        return -1
    }
    
    override var windowNibName: String!
    {
        return "ConfigureSheet"
    }
}
