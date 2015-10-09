import Cocoa

class PresetCell : NSView
{
    var scene:Cubes = Cubes()
    var preset:[String: AnyObject]? = nil
    var bitmap:NSBitmapImageRep? = nil

    override init(frame:NSRect)
    {
        super.init(frame: frame)
        dispatch_after(dispatch_time(0, 300), dispatch_get_main_queue(), self.animateOneFrame)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func restart()
    {
        if (index() < 0) { return }
        
        let ctx = NSGraphicsContext(bitmapImageRep: bitmap!)
        NSGraphicsContext.setCurrentContext(ctx)
        let w = Int(CGFloat(bitmap!.size.width) * 0.8)
        let h = Int(bitmap!.size.height)
        
        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()
        NSColor.blackColor().set()
        round.fill()
        
        NSColor.blackColor().set()
        NSBezierPath(rect: NSRect(x:0, y:0, width:w, height:h)).fill()
        let d = defaults()
        preset = d.presets[index()]
        scene.preset = preset
        scene.setup(false, width:w, height:h)
        let colorLists = Defaults.stringListToColorLists(preset!["colors"] as! [String])
        var listIndex = 0
        let numLists = CGFloat(colorLists.count)
        for colorList in colorLists
        {
            var colorIndex = 0
            for color in colorList
            {
                color.set()
                let num = CGFloat(colorList.count)
                let cw = CGFloat(bitmap!.size.width*0.2)
                let r = NSBezierPath(rect: NSRect(x:CGFloat(w)+CGFloat(colorIndex)*cw/num,
                    y:CGFloat(h)-CGFloat(listIndex+1)*CGFloat(h)/numLists,
                    width:cw/num,
                    height:CGFloat(h)/numLists))
                r.fill()
                colorIndex++
            }
            listIndex++
        }
    }

    func animateOneFrame()
    {
        if (index() < 0) { return }
        
        dispatch_after(dispatch_time(0, 15000000), dispatch_get_main_queue(), self.animateOneFrame)
        if bitmap == nil
        {
            bitmap = bitmapImageRepForCachingDisplayInRect(bounds)
        }
        drawScene()
        self.needsDisplay = true
    }
    
    override func drawRect(dirtyRect: NSRect)
    {
        bitmap?.drawAtPoint(NSPoint(x: 0,y: 0))
    }
    
    func drawScene()
    {
        if window == nil
        {
            return
        }
        let ctx = NSGraphicsContext(bitmapImageRep: bitmap!)
        NSGraphicsContext.setCurrentContext(ctx)

        scene.nextStep()
        
        if scene.isDone()
        {
            restart()
        }
    }
    
    func defaults() -> Defaults { return (window!.delegate as! SheetController).defaults }
    
    func table() -> TableView? { return superview?.superview?.superview as? TableView }
    
    func index() -> Int { if (table() != nil) { return table()!.rowForView(self) }; return -1 }
}
