import Cocoa

class SheetController : NSWindowController, NSTableViewDelegate
{
    var defaults = Defaults()
    
    @IBOutlet var colorsPage: NSView?
    @IBOutlet var colorLists: NSTableView?
    @IBOutlet var colors:     NSTableView?
    @IBOutlet var valuesView: NSTableView?
    @IBOutlet var pages:      NSTabView?
    @IBOutlet var rangeBox:   NSBox?
    @IBOutlet var valueBox:   NSBox?
    @IBOutlet var labelBox:   NSBox?
    @IBOutlet var titleBox:   NSBox?
    @IBOutlet var textBox:    NSBox?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        valuesView!.setDelegate(self)
        colorLists!.setDelegate(self)
        colors!.setDelegate(self)
        
        let indexes = NSIndexSet(indexesInRange: NSRange(location:0,length:defaults.values.count))
        valuesView!.insertRowsAtIndexes(indexes, withAnimation: NSTableViewAnimationOptions.EffectNone)
        
        let lists = NSIndexSet(indexesInRange: NSRange(location:0,length:defaults.colorLists.count))
        println(defaults.colorLists)
        colorLists!.insertRowsAtIndexes(lists, withAnimation: NSTableViewAnimationOptions.EffectNone)
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        switch tableView
        {
        case valuesView!:
            return addValueView(tableView, tableColumn:tableColumn, row:row)
        case colorLists!:
            return addColorListsView(tableView, tableColumn:tableColumn, row:row)
        case colors!:
            return addColorsView(tableView, tableColumn:tableColumn, row:row)
        default: return nil;
        }
    }
    
    func addColorListsView(tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let view = NSView()
        view.autoresizesSubviews = false
        let cell = ListCell()
        view.addSubview(cell)
        cell.initConstraints()
        return view
    }

    func addColorsView(tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        return NSColorWell();
    }

    func addValueView(tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        if tableColumn?.identifier == "label"
        {
            if (defaults.values[row]["title"] != nil)
            {
                var clone = titleBox!.clone()
                var label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = defaults.values[row]["title"] as! String
                label.drawsBackground = false
                label.editable = false
                label.selectable = false
                label.alignment = .RightTextAlignment
                return clone
            }
            else
            {
                var clone = labelBox!.clone()
                var label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = defaults.values[row]["label"] as! String
                label.drawsBackground = false
                label.editable = false
                label.selectable = false
                label.alignment = .RightTextAlignment
                return clone
            }
        }
        else if tableColumn?.identifier == "value"
        {
            if (defaults.values[row]["text"] != nil)
            {
                var clone = textBox!.clone()
                var label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = defaults.values[row]["text"] as! String
                label.drawsBackground = false
                label.editable = false
                label.selectable = false
                label.alignment = .LeftTextAlignment
                return clone
            }
            else if (defaults.values[row]["values"] != nil)
            {
                var clone = rangeBox!.clone()
                var box = clone.subviews.first! as! NSView
                box.identifier = defaults.values[row]["key"] as? String
                
                var minSlider = box.childWithIdentifier("minSlider") as! NSSlider
                var maxSlider = box.childWithIdentifier("maxSlider") as! NSSlider
                var minText   = box.childWithIdentifier("minText") as! NSTextField
                var maxText   = box.childWithIdentifier("maxText") as! NSTextField
                
                let minRange = (defaults.values[row]["range"]  as! [Double]).first! as Double
                let maxRange = (defaults.values[row]["range"]  as! [Double]).last!  as Double
                let minValue = (defaults.values[row]["values"] as! [Double]).first! as Double
                let maxValue = (defaults.values[row]["values"] as! [Double]).last!  as Double
                
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
            else if (defaults.values[row]["value"] != nil)
            {
                var clone = valueBox!.clone()
                var box = clone.subviews.first! as! NSView
                box.identifier = defaults.values[row]["key"] as? String
                
                var valueSlider = box.childWithIdentifier("valueSlider") as! NSSlider
                var valueText   = box.childWithIdentifier("valueText") as! NSTextField
                
                let minRange = (defaults.values[row]["range"] as! [Double]).first! as Double
                let maxRange = (defaults.values[row]["range"] as! [Double]).last! as Double
                let value    =  defaults.values[row]["value"] as! Double
                
                valueText.doubleValue = value
                valueSlider.minValue = minRange
                valueSlider.maxValue = maxRange
                valueSlider.doubleValue = value
                valueSlider.target = self
                valueSlider.action = Selector("sliderChanged:")
                
                return clone
            }
        }
        return nil
    }
    
    @IBAction func colorListSelected(sender: AnyObject)
    {
        println(sender)
    }
    
    func tableViewSelectionDidChange(notification: NSNotification)
    {
        println("didChange")
        println(notification.object)
    }
    
    @IBAction func sliderChanged(sender: AnyObject)
    {
        let slider = sender as! NSSlider
        let box    = slider.superview!
        let row    = rowForKey(box.identifier!)
        let step   = defaults.values[row]["step"] as! Double
        let value  = valueStep(slider.doubleValue, step)

        var textId = ""
        switch slider.identifier!
        {
        case "minSlider": textId = "minText"
        case "maxSlider": textId = "maxText"
        default:          textId = "valueText"
        }
        
        var text = box.childWithIdentifier(textId) as! NSTextField
        text.doubleValue = value
        
        if slider.identifier == "minSlider"
        {
            let otherSlider = box.childWithIdentifier("maxSlider") as! NSSlider
            let otherText   = box.childWithIdentifier("maxText") as! NSTextField
            otherSlider.doubleValue = max(otherSlider.doubleValue, slider.doubleValue)
            otherText.doubleValue = max(otherText.doubleValue, value)
            
            defaults.values[row]["values"] = [value, otherText.doubleValue]
        }
        else if slider.identifier == "maxSlider"
        {
            let otherSlider = box.childWithIdentifier("minSlider") as! NSSlider
            let otherText   = box.childWithIdentifier("minText") as! NSTextField
            otherSlider.doubleValue = min(otherSlider.doubleValue, slider.doubleValue)
            otherText.doubleValue = min(otherText.doubleValue, value)
            
            defaults.values[row]["values"] = [otherText.doubleValue, value]
        }
        else if slider.identifier == "valueSlider"
        {
            defaults.values[row]["value"] = value
        }
        
        updateDefaults(self)
    }
    
    @IBAction func addColorList(sender: AnyObject)
    {
        println("addColorList")
        defaults.colorLists += [[colorRGB([0.0,0.0,0.0])]]
    }

    @IBAction func delColorList(sender: AnyObject)
    {
        println("delColorList")
    }

    @IBAction func addColor(sender: AnyObject)
    {
        println("addColor")
    }
    
    @IBAction func delColor(sender: AnyObject)
    {
        println("delColor")
    }

    @IBAction func showPage(sender: AnyObject)
    {
        pages?.selectTabViewItemAtIndex(sender.selectedSegment)
    }
    
    @IBAction func updateDefaults(sender: AnyObject)
    {
        println(defaults.values)
        defaults.values = defaults.values
    }
   
    @IBAction func closeConfigureSheet(sender: AnyObject)
    {
        NSApp.endSheet(window!)
    }
    
    func rowForKey(key:String) -> Int
    {
        for index in 0...defaults.values.count
        {
            if (defaults.values[index]["key"] as? String) == key
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
