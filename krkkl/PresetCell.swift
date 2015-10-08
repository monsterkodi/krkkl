import Cocoa

class PresetsCell : NSView
{
    override func drawRect(rect:NSRect)
    {
        NSGraphicsContext.saveGraphicsState()
        
        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()
        
        NSColor.blackColor().set()
        round.fill()

        let d = defaults()
        let preset = d.presets[index()] as [String: AnyObject]
        let colorLists = d.stringListToColorLists(preset["colors"] as! [String])
        var listIndex = 0
        let numLists = CGFloat(colorLists.count)
        for colorList in colorLists
        {
            var colorIndex = 0
            for color in colorList
            {
                color.set()
                let num = CGFloat(colorList.count)
                let r = NSBezierPath(rect: NSRect(x:bounds.width*0.5+CGFloat(colorIndex)*bounds.width*0.5/num,
                                                  y:bounds.height-CGFloat(listIndex+1)*bounds.height/numLists,
                                                    width:bounds.width*0.5/num,
                                                    height:bounds.height/numLists))
                r.fill()
                colorIndex++
            }
            listIndex++
        }
        
        defaults().presetIndex = index()
        let scene = Cubes(defaults_: defaults())
        scene.setup(true, width: Int(bounds.width/2), height: Int(bounds.height))
        for _ in 0...500
        {
            scene.drawNextCube()
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
