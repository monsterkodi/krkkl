import Cocoa

class SheetController : NSWindowController, NSTableViewDelegate, NSWindowDelegate
{
    let defaults = Defaults()
    
    @IBOutlet var colorsPage:  NSView?
    @IBOutlet var colorLists:  TableView?
    @IBOutlet var colors:      TableView?
    @IBOutlet var valuesView:  TableView?
    @IBOutlet var presetView:  TableView?
    @IBOutlet var pages:       NSTabView?
    @IBOutlet var choiceBox:   NSBox?
    @IBOutlet var rangeBox:    NSBox?
    @IBOutlet var valueBox:    NSBox?
    @IBOutlet var labelBox:    NSBox?
    @IBOutlet var titleBox:    NSBox?
    @IBOutlet var textBox:     NSBox?
    @IBOutlet var colorBox:    NSBox?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        presetView!.setDelegate(self)
        valuesView!.setDelegate(self)
        colorLists!.setDelegate(self)
        colors!.setDelegate(self)
        window!.delegate = self

        presetView!.addAction = Selector("addPreset:")
        presetView!.delAction = Selector("delPreset:")
        colorLists!.addAction = Selector("addColorList:")
        colorLists!.delAction = Selector("delColorList:")
        colors!.addAction     = Selector("addColor:")
        colors!.delAction     = Selector("delColor:")
        colorLists!.nextKeyView = colors!
        
        presetView!.insertRows(defaults.presets.count)
        presetView!.selectRow(defaults.presetIndex)
        setPreset(defaults.presetIndex)
    }

    /*
      000000000   0000000   0000000    000      00000000   0000000
         000     000   000  000   000  000      000       000     
         000     000000000  0000000    000      0000000   0000000 
         000     000   000  000   000  000      000            000
         000     000   000  0000000    0000000  00000000  0000000 
    */

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        switch tableView
        {
        case presetView!: return addPresetView    (tableView, tableColumn:tableColumn, row:row)
        case valuesView!: return addValueView     (tableView, tableColumn:tableColumn, row:row)
        case colorLists!: return addColorListsView(tableView, tableColumn:tableColumn, row:row)
        case colors!:     return addColorsView    (tableView, tableColumn:tableColumn, row:row)
        default: return nil;
        }
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView?
    {
        if tableView == colors
        {
            return ColorsTableRow()
        }
        return TableRow()
    }
    
    /*
      00000000   00000000   00000000   0000000  00000000  000000000   0000000
      000   000  000   000  000       000       000          000     000     
      00000000   0000000    0000000   0000000   0000000      000     0000000 
      000        000   000  000            000  000          000          000
      000        000   000  00000000  0000000   00000000     000     0000000 
    */
    
    @IBAction func addPreset(sender: AnyObject)
    {
        let row = presetView!.selectedRow+1
        let defaultPreset = defaults.defaultPreset()
        defaults.presets.insert(defaultPreset, atIndex:row)
        presetView!.insertRow(row)
        presetView!.selectRow(row)
        setPreset(presetView!.selectedRow)
    }
    
    @IBAction func delPreset(sender: AnyObject)
    {
        let row = presetView!.selectedRow
        if row >= 0 && defaults.presets.count > 1
        {
            presetView!.selectRow(row==presetView!.numberOfRows-1 ? row-1 : row+1)
            defaults.presets.removeAtIndex(row)
            presetView!.removeRow(row)
            setPreset(presetView!.selectedRow)
        }
    }
    
    func addPresetView(tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let view = NSView()
        let cell = PresetCell()
        cell.autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
        view.addSubview(cell)
        return view
    }
    
    @IBAction func duplicatePreset(sender: AnyObject)
    {
        let row = presetView!.selectedRow
        defaults.presets.insert(defaults.presets[defaults.presetIndex], atIndex:row)
        presetView!.insertRow(row)
        presetView!.selectRow(row)
        setPreset(presetView!.selectedRow)
    }
    
    @IBAction func copyPresets(sender: AnyObject)
    {
        let pasteBoard = NSPasteboard.generalPasteboard()
        pasteBoard.clearContents()
        let data = try? NSJSONSerialization.dataWithJSONObject(defaults.presets, options:NSJSONWritingOptions.PrettyPrinted)
        let encd = data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        pasteBoard.setString(encd, forType:NSPasteboardTypeString)
    }
    
    @IBAction func restoreDefaultPresets(sender: AnyObject)
    {
        defaults.restoreDefaults()
        presetView!.clear()
        presetView!.insertRows(defaults.presets.count)
        presetView!.selectRow(0)
        setPreset(presetView!.selectedRow)
    }
    
    @IBAction func presetSelected(sender: AnyObject)
    {
        setPreset((sender as! TableView).selectedRow)
    }
    
    func setPreset(index: Int)
    {
        defaults.presetIndex = index
        valuesView!.clear()
        valuesView!.insertRows(defaults.values.count)
        colorLists!.clear()
        colorLists!.insertRows(defaults.colorLists.count)
    }
    
    /*
       0000000   0000000   000       0000000   00000000   000   000  000  00000000  000   000   0000000
      000       000   000  000      000   000  000   000  000   000  000  000       000 0 000  000     
      000       000   000  000      000   000  0000000     000 000   000  0000000   000000000  0000000 
      000       000   000  000      000   000  000   000     000     000  000       000   000       000
       0000000   0000000   0000000   0000000   000   000      0      000  00000000  00     00  0000000 
    */
    
    func addColorListsView(tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let view = NSView()
        let cell = ListCell()
        cell.autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
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
            return colorCell
        }
        return nil
    }
    
    /*
       0000000   0000000   000       0000000   00000000   000      000   0000000  000000000   0000000
      000       000   000  000      000   000  000   000  000      000  000          000     000     
      000       000   000  000      000   000  0000000    000      000  0000000      000     0000000 
      000       000   000  000      000   000  000   000  000      000       000     000          000
       0000000   0000000   0000000   0000000   000   000  0000000  000  0000000      000     0000000 
    */

    @IBAction func colorListSelected(sender: AnyObject)
    {
        showColorList(sender as! NSTableView)
    }
    
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
        colors?.selectRow(0)
    }

    @IBAction func addColorList(sender: AnyObject)
    {
        let row = colorLists!.selectedRow+1
        defaults.colorLists.insert([randColor()], atIndex:row)
        colorLists!.insertRow(row)
        colorLists!.selectRow(row)
    }

    @IBAction func delColorList(sender: AnyObject)
    {
        let row = colorLists!.selectedRow
        if defaults.colorLists.count <= 1 { return }
        if row >= 0
        {
            colorLists!.selectRow(row==colorLists!.numberOfRows-1 ? row-1 : row+1)
            defaults.colorLists.removeAtIndex(row)
            colorLists!.removeRow(row)
        }
    } 

    @IBAction func copyColorLists(sender: AnyObject)
    {
        let pasteBoard = NSPasteboard.generalPasteboard()
        pasteBoard.clearContents()

        let colorListsStr = defaults.colorLists.map { (colorList) -> String in
            return colorList.map { (color) -> String in
                    return color.hex()
                }.joinWithSeparator("")
        }.joinWithSeparator(",")
        print(colorListsStr)
        let data = colorListsStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:false)!
        pasteBoard.setData(data, forType:NSPasteboardTypeString)
    }

    @IBAction func duplicateColorList(sender: AnyObject)
    {
        let row = colorLists!.selectedRow+1
        defaults.colorLists.insert(defaults.colorLists[colorLists!.selectedRow], atIndex:row)
        colorLists!.insertRow(row)
        colorLists!.selectRow(row)
    }
    
    @IBAction func restoreDefaultColorLists(sender: AnyObject)
    {
        defaults.presets[defaults.presetIndex]["colors"] = defaults.defaultPreset()["colors"]
        
        colorLists!.clear()
        colors!.clear()
        colorLists!.insertRows(defaults.colorLists.count)
        colorLists!.selectRow(0)
    }
    
    func updateColorList(listIndex:Int)
    {
        let cell = ((colorLists?.rowViewAtRow(listIndex, makeIfNecessary:false)!.subviews.first)!.subviews.first) as! ListCell
        cell.needsDisplay = true
    }

    /*
       0000000   0000000   000       0000000   00000000    0000000
      000       000   000  000      000   000  000   000  000     
      000       000   000  000      000   000  0000000    0000000 
      000       000   000  000      000   000  000   000       000
       0000000   0000000   0000000   0000000   000   000  0000000 
    */

    @IBAction func addColor(sender: AnyObject)
    {
        let listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            let row = colors!.selectedRow + 1
            let color = randColor()
            defaults.colorLists[listIndex].insert(color, atIndex:row)
            colors!.insertRow(row)
            colors!.selectRow(row)
            updateColorList(listIndex)
        }
    }

    @IBAction func delColor(sender: AnyObject)
    {
        let row = colors!.selectedRow
        if row >= 0
        {
            let listIndex = colorLists!.selectedRow
            colors!.selectRow(row==colors!.numberOfRows-1 ? row-1 : row+1)
            defaults.colorLists[listIndex].removeAtIndex(row)
            colors!.removeRow(row)
            updateColorList(listIndex)
        }
    }

    func colorCellChanged(sender:AnyObject)
    {
        let colorCell = sender as! ColorCell
        let listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            defaults.colorLists[listIndex][colorCell.index()] = colorCell.rgb()
            updateColorList(listIndex)
        }
    }
    
    @IBAction func darkenColor(sender: AnyObject)
    {
        let listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            let row = colors?.rowViewAtRow(colors!.selectedRow, makeIfNecessary:false)
            let cell = row!.subviews.first as! ColorCell
            let color = defaults.colorLists[listIndex][colors!.selectedRow].scale(0.8)
            cell.color = color
            defaults.colorLists[listIndex][colors!.selectedRow] = color
            updateColorList(listIndex)
        }
    }

    @IBAction func lightenColor(sender: AnyObject)
    {
        let listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            let row = colors?.rowViewAtRow(colors!.selectedRow, makeIfNecessary:false)
            let cell = row!.subviews.first as! ColorCell
            let color = defaults.colorLists[listIndex][colors!.selectedRow].scale(1.2)
            cell.color = color
            defaults.colorLists[listIndex][colors!.selectedRow] = color
            updateColorList(listIndex)
        }
    }

    @IBAction func showMenu(sender: AnyObject)
    {
        let pos = CGPoint(x:-sender.frame.size.width*2+5, y:sender.frame.size.height+3)
        let menu = sender.menu as NSMenu?
        let view = sender as! NSView
        menu!.popUpMenuPositioningItem(menu?.itemArray.first, atLocation:pos, inView:view)
    }

    /*
      000   000   0000000   000      000   000  00000000   0000000
      000   000  000   000  000      000   000  000       000     
       000 000   000000000  000      000   000  0000000   0000000 
         000     000   000  000      000   000  000            000
          0      000   000  0000000   0000000   00000000  0000000 
    */

    func addValueView(tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        if tableColumn?.identifier == "label"
        {
            if (defaults.values[row]["title"] != nil)
            {
                let clone = titleBox!.clone()
                let label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = defaults.values[row]["title"] as! String
                label.drawsBackground = false
                label.editable = false
                label.selectable = false
                label.alignment = .Right
                return clone
            }
            else
            {
                let clone = labelBox!.clone()
                let label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = defaults.values[row]["label"] as! String
                label.drawsBackground = false
                label.editable = false
                label.selectable = false
                label.alignment = .Right
                return clone
            }
        }
        else if tableColumn?.identifier == "value"
        {
            if (defaults.values[row]["text"] != nil)
            {
                let clone = textBox!.clone()
                let label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = defaults.values[row]["text"] as! String
                label.drawsBackground = false
                label.editable = false
                label.selectable = false
                return clone
            }
            else if (defaults.values[row]["choices"] != nil)
            {
                let clone = choiceBox!.clone()
                let box = clone.subviews.first! 
                box.identifier = defaults.values[row]["key"] as? String
                let segments = box.childWithIdentifier("segments") as! NSSegmentedControl
                var choices = defaults.values[row]["choices"] as! [AnyObject]
                let type = defaults.values[row]["type"] as! String
                
                segments.target = self
                segments.action = Selector("segmentsChanged:")

                segments.segmentCount = choices.count
                for i in 0...choices.count-1
                {
                    segments.setLabel((defaults.values[row]["labels"] as! [String])[i], forSegment: i)
                    var found = false
                    if type == "string"
                    {
                        found = (defaults.values[row]["values"] as! [String]).indexOf((choices[i] as! String)) != nil
                    }
                    else
                    {
                        found = (defaults.values[row]["values"] as! [Int]).indexOf(choices[i] as! Int) != nil
                    }
                    segments.setSelected(found, forSegment: i)
                }
                return clone
            }
            else if (defaults.values[row]["values"] != nil)
            {
                let clone = rangeBox!.clone()
                let box = clone.subviews.first! 
                box.identifier = defaults.values[row]["key"] as? String
                
                let minSlider = box.childWithIdentifier("minSlider") as! NSSlider
                let maxSlider = box.childWithIdentifier("maxSlider") as! NSSlider
                let minText   = box.childWithIdentifier("minText") as! NSTextField
                let maxText   = box.childWithIdentifier("maxText") as! NSTextField
                
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
                let clone = valueBox!.clone()
                let box = clone.subviews.first! 
                box.identifier = defaults.values[row]["key"] as? String
                
                let valueSlider = box.childWithIdentifier("valueSlider") as! NSSlider
                let valueText   = box.childWithIdentifier("valueText") as! NSTextField
                
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
    
    /*
       0000000  000      000  0000000    00000000  00000000 
      000       000      000  000   000  000       000   000
      0000000   000      000  000   000  0000000   0000000  
           000  000      000  000   000  000       000   000
      0000000   0000000  000  0000000    00000000  000   000
    */

    @IBAction func sliderChanged(sender: AnyObject)
    {
        let slider = sender as! NSSlider
        let box    = slider.superview!
        let row    = rowForKey(box.identifier!)
        let step   = defaults.values[row]["step"] as! Double
        let value  = valueStep(slider.doubleValue, step: step)

        var textId = ""
        switch slider.identifier!
        {
        case "minSlider": textId = "minText"
        case "maxSlider": textId = "maxText"
        default:          textId = "valueText"
        }
        
        let text = box.childWithIdentifier(textId) as! NSTextField
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

    @IBAction func segmentsChanged(sender: AnyObject)
    {
        let segments = sender as! NSSegmentedControl
        let box    = segments.superview!
        let row    = rowForKey(box.identifier!)

        var choices = defaults.values[row]["choices"] as! [AnyObject]
        var values = defaults.values[row]["values"] as! [AnyObject]
        values.removeAll(keepCapacity:true)
        for i in 0...choices.count-1
        {
            if segments.isSelectedForSegment(i)
            {
                values.append(choices[i])
            }
        }
        defaults.values[row]["values"] = values
    }
    
    /*
      00     00  000   0000000   0000000
      000   000  000  000       000     
      000000000  000  0000000   000     
      000 0 000  000       000  000     
      000   000  000  0000000    0000000
    */

    @IBAction func showPage(sender: AnyObject)
    {
        pages?.selectTabViewItemAtIndex(sender.selectedSegment)
        if sender.selectedSegment == 2
        {
            colorLists?.selectRow(0)
        }
        else if sender.selectedSegment == 0
        {
            let cell = presetView!.viewAtColumn(0, row: presetView!.selectedRow, makeIfNecessary: false)?.subviews.first as! PresetCell
            cell.restart()
        }
    }
    
    @IBAction func updateDefaults(sender: AnyObject)
    {
        defaults.presets = defaults.presets
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
