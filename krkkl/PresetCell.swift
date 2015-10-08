import Cocoa

class PresetsCell : NSView
{
    var scene:Cubes? = nil
    var bitmap:NSBitmapImageRep? = nil

    override init(frame:NSRect)
    {
        super.init(frame: frame)
        dispatch_after(dispatch_time(0, 60000000), dispatch_get_main_queue(), self.animateOneFrame)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func animateOneFrame()
    {
        dispatch_after(dispatch_time(0, 60000000), dispatch_get_main_queue(), self.animateOneFrame)
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

        defaults().presetIndex = index()

        let round = NSBezierPath(roundedRect: NSRect(x:0, y:0, width:bounds.width, height:bounds.height), xRadius:5, yRadius:5)
        round.addClip()

        if scene == nil
        {
            NSColor.blackColor().set()
            round.fill()

            let w = Int(bitmap!.size.width)
            let h = Int(bitmap!.size.height)
            scene = Cubes(defaults_: defaults())
            scene!.setup(true, width:Int(CGFloat(w) * 0.8), height: h)

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
                    let r = NSBezierPath(rect: NSRect(x:CGFloat(w)*0.8+CGFloat(colorIndex)*CGFloat(w)*0.2/num,
                                                      y:CGFloat(h)-CGFloat(listIndex+1)*CGFloat(h)/numLists,
                                                        width:CGFloat(w)*0.2/num,
                                                        height:CGFloat(h)/numLists))
                    r.fill()
                    colorIndex++
                }
                listIndex++
            }
        }
        
        scene?.nextStep()
    }
    
    func defaults() -> Defaults { return (window!.delegate as! SheetController).defaults }
    
    func table() -> TableView { return superview!.superview!.superview as! TableView }
    
    func index() -> Int { return table().rowForView(self) }    
}
