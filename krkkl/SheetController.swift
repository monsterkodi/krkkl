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
    @IBOutlet var colorBox:   NSBox?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        valuesView!.setDelegate(self)
        colorLists!.setDelegate(self)
        colors!.setDelegate(self)
                
        var indexes = NSIndexSet(indexesInRange: NSRange(location:0,length:defaults.values.count))
        valuesView!.insertRowsAtIndexes(indexes, withAnimation: NSTableViewAnimationOptions.EffectNone)
        
        indexes = NSIndexSet(indexesInRange: NSRange(location:0,length:defaults.colorLists.count))
        colorLists!.insertRowsAtIndexes(indexes, withAnimation: NSTableViewAnimationOptions.EffectNone)
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        switch tableView
        {
        case valuesView!: return addValueView     (tableView, tableColumn:tableColumn, row:row)
        case colorLists!: return addColorListsView(tableView, tableColumn:tableColumn, row:row)
        case colors!:     return addColorsView    (tableView, tableColumn:tableColumn, row:row)
        default: return nil;
        }
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView?
    {
        return TableRow()
    }
    
    func addColorListsView(tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let view = NSView()
        let cell = ListCell()
        cell.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable
        view.addSubview(cell)
        return view
    }

    func addColorsView(tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let listIndex = colorLists!.selectedRow
        let color = defaults.colorLists[listIndex][row]
        if tableColumn?.identifier == "color"
        {
            let colorCell = ColorCell(color:color)
            colorCell.bordered = false
            colorCell.action = Selector("colorCellChanged:")
            colorCell.target = self
            colorCell.index = row
            return colorCell
        }
        else
        {
            var clone = colorBox!.clone()
            var label = clone.subviews.first!.subviews.first! as! NSTextField
            switch tableColumn!.identifier
            {
            case "red":   label.stringValue = String(Int(color.red()*255))
            case "green": label.stringValue = String(Int(color.green()*255))
            case "blue":  label.stringValue = String(Int(color.blue()*255))
            default: break
            }
            
            label.drawsBackground = false
            label.editable = false
            label.selectable = false
            label.alignment = .RightTextAlignment
            return clone
        }
    }
    
    func colorCellChanged(sender:AnyObject)
    {
        let colorCell = sender as! ColorCell
        println("colorCellChanged \(colorCell.index)")
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
    
    @IBAction func colorListSelected(sender: AnyObject) { showColorList(sender as! NSTableView) }
    func tableViewSelectionDidChange(notification: NSNotification)
    {
        let table = notification.object as! NSTableView
        if table == colorLists
        {
            showColorList(table)
        }
    }
    
    func showColorList(table:NSTableView)
    {
        let row = table.selectedRow
        var indexes = NSIndexSet(indexesInRange: NSRange(location:0,length:colors!.numberOfRows))
        colors!.removeRowsAtIndexes(indexes, withAnimation: NSTableViewAnimationOptions.EffectNone)
        if row >= 0
        {
            indexes = NSIndexSet(indexesInRange: NSRange(location:0,length:defaults.colorLists[row].count))
            colors!.insertRowsAtIndexes(indexes, withAnimation: NSTableViewAnimationOptions.EffectNone)
        }
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
        var row = colorLists!.selectedRow+1
        defaults.colorLists.insert([colorRGB([0.0,0.0,0.0])], atIndex:row)
        colorLists!.insertRowsAtIndexes(NSIndexSet(index:row), withAnimation: NSTableViewAnimationOptions.SlideLeft)
        colorLists!.selectRowIndexes(NSIndexSet(index:row), byExtendingSelection:false)
    }

    @IBAction func delColorList(sender: AnyObject)
    {
        let row = colorLists!.selectedRow
        if row >= 0
        {
            colorLists!.selectRowIndexes(NSIndexSet(index:row==colorLists!.numberOfRows-1 ? row-1 : row+1), byExtendingSelection:false)
            defaults.colorLists.removeAtIndex(row)
            colorLists!.removeRowsAtIndexes(NSIndexSet(index:row), withAnimation: NSTableViewAnimationOptions.SlideRight)
        }
    }

    @IBAction func addColor(sender: AnyObject)
    {
        var listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            var row = colors!.selectedRow + 1
            let color = randColor()
            defaults.colorLists[listIndex].insert(color, atIndex:row)
            colors!.insertRowsAtIndexes(NSIndexSet(index:row), withAnimation: NSTableViewAnimationOptions.SlideLeft)
            colors!.selectRowIndexes(NSIndexSet(index:row), byExtendingSelection:false)
        }
    }
    
    @IBAction func delColor(sender: AnyObject)
    {
        let row = colors!.selectedRow
        if row >= 0
        {
            println("delColor \(row)")
            var listIndex = colorLists!.selectedRow
            colors!.selectRowIndexes(NSIndexSet(index:row==colors!.numberOfRows-1 ? row-1 : row+1), byExtendingSelection:false)
            defaults.colorLists[listIndex].removeAtIndex(row)
            colors!.removeRowsAtIndexes(NSIndexSet(index:row), withAnimation: NSTableViewAnimationOptions.SlideRight)
        }
    }

    @IBAction func showPage(sender: AnyObject)
    {
        pages?.selectTabViewItemAtIndex(sender.selectedSegment)
        if sender.selectedSegment == 1
        {
            colorLists?.selectRowIndexes(NSIndexSet(index:0), byExtendingSelection:false)
        }
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
