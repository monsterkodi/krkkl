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
        presetView!.delegate = self
        valuesView!.delegate = self
        colorLists!.delegate = self
        colors!.delegate = self
        window!.delegate = self

        presetView!.addAction = #selector(SheetController.addPreset(_:))
        presetView!.delAction = #selector(SheetController.delPreset(_:))
        colorLists!.addAction = #selector(SheetController.addColorList(_:))
        colorLists!.delAction = #selector(SheetController.delColorList(_:))
        colors!.addAction     = #selector(SheetController.addColor(_:))
        colors!.delAction     = #selector(SheetController.delColor(_:))
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

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
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
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView?
    {
        if tableView == colors
        {
            return ColorsTableRow()
        }
        return TableRow()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification)
    {
        let table = notification.object as! NSTableView
        if table == colorLists
        {
            showColorList(table)
        }
        else if table == presetView
        {
            setPreset(max(presetView!.selectedRow, 0))
        }
    }
    
    /*
      00000000   00000000   00000000   0000000  00000000  000000000   0000000
      000   000  000   000  000       000       000          000     000     
      00000000   0000000    0000000   0000000   0000000      000     0000000 
      000        000   000  000            000  000          000          000
      000        000   000  00000000  0000000   00000000     000     0000000 
    */
    
    @IBAction func addPreset(_ sender: AnyObject)
    {
        let row = presetView!.selectedRow+1
        let defaultPreset = defaults.defaultPreset()
        defaults.presets.insert(defaultPreset, at:row)
        presetView!.insertRow(row)
        presetView!.selectRow(row)
        setPreset(presetView!.selectedRow)
    }
    
    @IBAction func delPreset(_ sender: AnyObject)
    {
        let row = presetView!.selectedRow
        if row >= 0 && defaults.presets.count > 1
        {
//            presetCellAtRow(row).stop()
            presetView!.selectRow(row==presetView!.numberOfRows-1 ? row-1 : row+1)
            defaults.presets.remove(at: row)
            presetView!.removeRow(row)
            setPreset(presetView!.selectedRow)
        }
    }
    
    func addPresetView(_ tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let view = NSView()
        let cell = PresetCell()
        cell.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
        view.addSubview(cell)
        return view
    }
    
    @IBAction func duplicatePreset(_ sender: AnyObject)
    {
        let row = presetView!.selectedRow
        defaults.presets.insert(defaults.presets[defaults.presetIndex], at:row)
        presetView!.insertRow(row)
        presetView!.selectRow(row)
        setPreset(presetView!.selectedRow)
    }
    
    @IBAction func copyPresets(_ sender: AnyObject)
    {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        let data = try? JSONSerialization.data(withJSONObject: defaults.presets, options:JSONSerialization.WritingOptions.prettyPrinted)
        print(String(data:data!, encoding:String.Encoding.utf8) ?? "can't decode")
        let encd = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        pasteBoard.setString(encd, forType:NSPasteboard.PasteboardType.string)
    }
    
    @IBAction func restoreDefaultPresets(_ sender: AnyObject)
    {
        defaults.restoreDefaults()
        presetView!.clear()
        presetView!.insertRows(defaults.presets.count)
        presetView!.selectRow(0)
        setPreset(presetView!.selectedRow)
    }
    
    func setPreset(_ index: Int)
    {
        defaults.presetIndex = index
        valuesView!.clear()
        valuesView!.insertRows(Defaults.defaultInfo.count)
        colorLists!.clear()
        colorLists!.insertRows(defaults.colorLists.count)
    }
    
    func presetCellAtRow(_ row: Int) -> PresetCell
    {
        return presetView!.view(atColumn: 0, row: row, makeIfNecessary: false)?.subviews.first as! PresetCell
    }
    
    /*
       0000000   0000000   000       0000000   00000000   000   000  000  00000000  000   000   0000000
      000       000   000  000      000   000  000   000  000   000  000  000       000 0 000  000     
      000       000   000  000      000   000  0000000     000 000   000  0000000   000000000  0000000 
      000       000   000  000      000   000  000   000     000     000  000       000   000       000
       0000000   0000000   0000000   0000000   000   000      0      000  00000000  00     00  0000000 
    */
    
    func addColorListsView(_ tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let view = NSView()
        let cell = ListCell()
        cell.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
        view.addSubview(cell)
        return view
    }

    func addColorsView(_ tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let listIndex = colorLists!.selectedRow
        let color = defaults.colorLists[listIndex][row]
        if convertFromNSUserInterfaceItemIdentifier((tableColumn?.identifier)!) == "color"
        {
            let colorCell = ColorCell(color:color)
            colorCell.isBordered = false
            colorCell.action = #selector(SheetController.colorCellChanged(_:))
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

    @IBAction func colorListSelected(_ sender: AnyObject)
    {
        showColorList(sender as! NSTableView)
    }
    
    func showColorList(_ table:NSTableView)
    {
        let row = table.selectedRow
        var indexes = IndexSet(integersIn: 0..<colors!.numberOfRows)
        colors!.removeRows(at: indexes, withAnimation: NSTableView.AnimationOptions())
        if row >= 0
        {
            indexes = IndexSet(integersIn: 0..<defaults.colorLists[row].count)
            colors!.insertRows(at: indexes, withAnimation: NSTableView.AnimationOptions())
        }
        colors?.selectRow(0)
    }

    @IBAction func addColorList(_ sender: AnyObject)
    {
        let row = colorLists!.selectedRow+1
        defaults.colorLists.insert([randColor()], at:row)
        colorLists!.insertRow(row)
        colorLists!.selectRow(row)
    }

    @IBAction func delColorList(_ sender: AnyObject)
    {
        let row = colorLists!.selectedRow
        if defaults.colorLists.count <= 1 { return }
        if row >= 0
        {
            colorLists!.selectRow(row==colorLists!.numberOfRows-1 ? row-1 : row+1)
            defaults.colorLists.remove(at: row)
            colorLists!.removeRow(row)
        }
    } 

    @IBAction func copyColorLists(_ sender: AnyObject)
    {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()

        let colorListsStr = defaults.colorLists.map { (colorList) -> String in
            return colorList.map { (color) -> String in
                    return color.hex()
                }.joined(separator: "")
        }.joined(separator: ",")
        print(colorListsStr)
        let data = colorListsStr.data(using: String.Encoding.utf8, allowLossyConversion:false)!
        pasteBoard.setData(data, forType:NSPasteboard.PasteboardType.string)
    }

    @IBAction func duplicateColorList(_ sender: AnyObject)
    {
        let row = colorLists!.selectedRow+1
        defaults.colorLists.insert(defaults.colorLists[colorLists!.selectedRow], at:row)
        colorLists!.insertRow(row)
        colorLists!.selectRow(row)
    }
    
    @IBAction func restoreDefaultColorLists(_ sender: AnyObject)
    {
        defaults.presets[defaults.presetIndex]["colors"] = defaults.defaultPreset()["colors"]
        
        colorLists!.clear()
        colors!.clear()
        colorLists!.insertRows(defaults.colorLists.count)
        colorLists!.selectRow(0)
    }
    
    func updateColorList(_ listIndex:Int)
    {
        let cell = ((colorLists?.rowView(atRow: listIndex, makeIfNecessary:false)!.subviews.first)!.subviews.first) as! ListCell
        cell.needsDisplay = true
    }

    /*
       0000000   0000000   000       0000000   00000000    0000000
      000       000   000  000      000   000  000   000  000     
      000       000   000  000      000   000  0000000    0000000 
      000       000   000  000      000   000  000   000       000
       0000000   0000000   0000000   0000000   000   000  0000000 
    */

    @IBAction func addColor(_ sender: AnyObject)
    {
        let listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            let row = colors!.selectedRow + 1
            let color = randColor()
            defaults.colorLists[listIndex].insert(color, at:row)
            colors!.insertRow(row)
            colors!.selectRow(row)
            updateColorList(listIndex)
        }
    }

    @IBAction func delColor(_ sender: AnyObject)
    {
        let row = colors!.selectedRow
        if row >= 0
        {
            let listIndex = colorLists!.selectedRow
            colors!.selectRow(row==colors!.numberOfRows-1 ? row-1 : row+1)
            defaults.colorLists[listIndex].remove(at: row)
            colors!.removeRow(row)
            updateColorList(listIndex)
        }
    }

    @objc func colorCellChanged(_ sender:AnyObject)
    {
        let colorCell = sender as! ColorCell
        let listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            defaults.colorLists[listIndex][colorCell.index()] = colorCell.rgb()
            updateColorList(listIndex)
        }
    }
    
    @IBAction func darkenColor(_ sender: AnyObject)
    {
        let listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            let row = colors?.rowView(atRow: colors!.selectedRow, makeIfNecessary:false)
            let cell = row!.subviews.first as! ColorCell
            let color = defaults.colorLists[listIndex][colors!.selectedRow].scale(0.8)
            cell.color = color
            defaults.colorLists[listIndex][colors!.selectedRow] = color
            updateColorList(listIndex)
        }
    }

    @IBAction func lightenColor(_ sender: AnyObject)
    {
        let listIndex = colorLists!.selectedRow
        if  listIndex >= 0
        {
            let row = colors?.rowView(atRow: colors!.selectedRow, makeIfNecessary:false)
            let cell = row!.subviews.first as! ColorCell
            let color = defaults.colorLists[listIndex][colors!.selectedRow].scale(1.2)
            cell.color = color
            defaults.colorLists[listIndex][colors!.selectedRow] = color
            updateColorList(listIndex)
        }
    }

    @IBAction func showMenu(_ sender: AnyObject)
    {
    }

    /*
      000   000   0000000   000      000   000  00000000   0000000
      000   000  000   000  000      000   000  000       000     
       000 000   000000000  000      000   000  0000000   0000000 
         000     000   000  000      000   000  000            000
          0      000   000  0000000   0000000   00000000  0000000 
    */

    func addValueView(_ tableView: NSTableView, tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let valueRow = Defaults.defaultInfo[row]
        if convertFromNSUserInterfaceItemIdentifier((tableColumn?.identifier)!) == "label"
        {
            if (valueRow["title"] != nil)
            {
                let clone = titleBox!.clone()
                let label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = valueRow["title"] as! String
                label.drawsBackground = false
                label.isEditable = false
                label.isSelectable = false
                label.alignment = .right
                return clone
            }
            else
            {
                let clone = labelBox!.clone()
                let label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = valueRow["label"] as! String
                label.drawsBackground = false
                label.isEditable = false
                label.isSelectable = false
                label.alignment = .right
                return clone
            }
        }
        else if convertFromNSUserInterfaceItemIdentifier((tableColumn?.identifier)!) == "value"
        {
            if (valueRow["text"] != nil)
            {
                let clone = textBox!.clone()
                let label = clone.subviews.first!.subviews.first! as! NSTextField
                label.stringValue = valueRow["text"] as! String
                label.drawsBackground = false
                label.isEditable = false
                label.isSelectable = false
                return clone
            }
            else if (valueRow["choices"] != nil)
            {
                let clone = choiceBox!.clone()
                let box = clone.subviews.first!
                let key = valueRow["key"] as! String

                box.identifier = convertToOptionalNSUserInterfaceItemIdentifier(key)
                let segments = box.childWithIdentifier("segments") as! NSSegmentedControl
                var choices = valueRow["choices"] as! [AnyObject]
                
                segments.target = self
                segments.action = #selector(SheetController.segmentsChanged(_:))

                segments.segmentCount = choices.count
                for i in 0...choices.count-1
                {
                    segments.setLabel((valueRow["labels"] as! [String])[i], forSegment: i)
                    let found = (defaults.values[key] as! [Int]).index(of: choices[i] as! Int) != nil
                    segments.setSelected(found, forSegment: i)
                }
                return clone
            }
            else if (valueRow["values"] != nil)
            {
                let clone = rangeBox!.clone()
                let box = clone.subviews.first!
                let key = valueRow["key"] as! String
                box.identifier = convertToOptionalNSUserInterfaceItemIdentifier(key)
                
                let minSlider = box.childWithIdentifier("minSlider") as! NSSlider
                let maxSlider = box.childWithIdentifier("maxSlider") as! NSSlider
                let minText   = box.childWithIdentifier("minText") as! NSTextField
                let maxText   = box.childWithIdentifier("maxText") as! NSTextField
                
                let minRange = (valueRow["range"]  as! [Double]).first! as Double
                let maxRange = (valueRow["range"]  as! [Double]).last!  as Double
                let minValue = (defaults.values[key] as! [Double]).first! as Double
                let maxValue = (defaults.values[key] as! [Double]).last!  as Double
                
                minText.doubleValue = minValue
                minSlider.minValue = minRange
                minSlider.maxValue = maxRange
                minSlider.doubleValue = minValue
                minSlider.target = self
                minSlider.action = #selector(SheetController.sliderChanged(_:))
                
                maxText.doubleValue = maxValue
                maxSlider.minValue = minRange
                maxSlider.maxValue = maxRange
                maxSlider.doubleValue = maxValue
                maxSlider.target = self
                maxSlider.action = #selector(SheetController.sliderChanged(_:))
                return clone
            }
            else if (valueRow["value"] != nil)
            {
                let clone = valueBox!.clone()
                let box = clone.subviews.first!
                let key = valueRow["key"] as! String
                box.identifier = convertToOptionalNSUserInterfaceItemIdentifier(key)
                
                let valueSlider = box.childWithIdentifier("valueSlider") as! NSSlider
                let valueText   = box.childWithIdentifier("valueText") as! NSTextField
                
                let minRange = (valueRow["range"] as! [Double]).first! as Double
                let maxRange = (valueRow["range"] as! [Double]).last! as Double
                let value    =  defaults.values[key] as! Double
                
                valueText.doubleValue = value
                valueSlider.minValue = minRange
                valueSlider.maxValue = maxRange
                valueSlider.doubleValue = value
                valueSlider.target = self
                valueSlider.action = #selector(SheetController.sliderChanged(_:))
                
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

    @IBAction func sliderChanged(_ sender: AnyObject)
    {
        let slider = sender as! NSSlider
        let box    = slider.superview!
        let key    = convertFromOptionalNSUserInterfaceItemIdentifier(box.identifier)!
        let row    = rowForKey(key)
        let step   = Defaults.defaultInfo[row]["step"] as! Double
        let value  = valueStep(slider.doubleValue, step: step)

        var textId = ""
        switch convertFromOptionalNSUserInterfaceItemIdentifier(slider.identifier)!
        {
        case "minSlider": textId = "minText"
        case "maxSlider": textId = "maxText"
        default:          textId = "valueText"
        }
        
        let text = box.childWithIdentifier(textId) as! NSTextField
        text.doubleValue = value
        
        if convertFromOptionalNSUserInterfaceItemIdentifier(slider.identifier) == "minSlider"
        {
            let otherSlider = box.childWithIdentifier("maxSlider") as! NSSlider
            let otherText   = box.childWithIdentifier("maxText") as! NSTextField
            otherSlider.doubleValue = max(otherSlider.doubleValue, slider.doubleValue)
            otherText.doubleValue = max(otherText.doubleValue, value)
            
            defaults.values[key] = [value, otherText.doubleValue] as AnyObject
        }
        else if convertFromOptionalNSUserInterfaceItemIdentifier(slider.identifier) == "maxSlider"
        {
            let otherSlider = box.childWithIdentifier("minSlider") as! NSSlider
            let otherText   = box.childWithIdentifier("minText") as! NSTextField
            otherSlider.doubleValue = min(otherSlider.doubleValue, slider.doubleValue)
            otherText.doubleValue = min(otherText.doubleValue, value)
            
            defaults.values[key] = [otherText.doubleValue, value] as AnyObject
        }
        else if convertFromOptionalNSUserInterfaceItemIdentifier(slider.identifier) == "valueSlider"
        {
            defaults.values[key] = value as AnyObject
        }
        
        updateDefaults(self)
    }

    @IBAction func segmentsChanged(_ sender: AnyObject)
    {
        let segments = sender as! NSSegmentedControl
        let box    = segments.superview!
        let key    = convertFromOptionalNSUserInterfaceItemIdentifier(box.identifier)!
        let row    = rowForKey(key)

        var choices = Defaults.defaultInfo[row]["choices"] as! [Int]
        var values = defaults.values[key] as! [Int]
        values.removeAll(keepingCapacity:true)
        for i in 0...choices.count-1
        {
            if segments.isSelected(forSegment: i)
            {
                values.append(choices[i])
            }
        }
        defaults.values[key] = values as AnyObject
    }
    
    /*
      00     00  000   0000000   0000000
      000   000  000  000       000     
      000000000  000  0000000   000     
      000 0 000  000       000  000     
      000   000  000  0000000    0000000
    */

    @IBAction func showPage(_ sender: AnyObject)
    {
        pages?.selectTabViewItem(at: sender.selectedSegment)
        if sender.selectedSegment == 2
        {
            colorLists?.selectRow(0)
        }
        else if sender.selectedSegment == 0
        {
            presetCellAtRow(presetView!.selectedRow).restart()
        }
    }
    
    @IBAction func updateDefaults(_ sender: AnyObject)
    {
        defaults.presets = defaults.presets
    }
   
    @IBAction func closeConfigureSheet(_ sender: AnyObject)
    {
        NSApp.endSheet(window!)
    }
    
    func rowForKey(_ key:String) -> Int
    {
        for index in 0...Defaults.defaultInfo.count
        {
            if (Defaults.defaultInfo[index]["key"] as? String) == key
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSUserInterfaceItemIdentifier(_ input: NSUserInterfaceItemIdentifier) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSUserInterfaceItemIdentifier(_ input: String?) -> NSUserInterfaceItemIdentifier? {
	guard let input = input else { return nil }
	return NSUserInterfaceItemIdentifier(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalNSUserInterfaceItemIdentifier(_ input: NSUserInterfaceItemIdentifier?) -> String? {
	guard let input = input else { return nil }
	return input.rawValue
}
