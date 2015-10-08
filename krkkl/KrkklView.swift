/*
  000   000  00000000   000   000  000   000  000    
  000  000   000   000  000  000   000  000   000    
  0000000    0000000    0000000    0000000    000    
  000  000   000   000  000  000   000  000   000    
  000   000  000   000  000   000  000   000  0000000
*/
import ScreenSaver

class KrkklView : ScreenSaverView
{
    let sheetController:SheetController = SheetController()
    
    var animState:String = "anim"
    var fadeCount:Int = 0
    var scene:Cubes

    override init(frame: NSRect, isPreview: Bool) 
    {
        scene = Cubes(defaults_: sheetController.defaults)
        super.init(frame: frame, isPreview: isPreview)!
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        scene = Cubes(defaults_:sheetController.defaults)
        super.init(coder: aDecoder)
    }

    /*
       0000000   000   000  000  00     00
      000   000  0000  000  000  000   000
      000000000  000 0 000  000  000000000
      000   000  000  0000  000  000 0 000
      000   000  000   000  000  000   000
    */
            
    override func startAnimation() 
    {    
        scene.setup(self.preview, width: self.width(), height: self.height())
        super.startAnimation()
        animationTimeInterval = 1.0 / scene.fps
        needsDisplay = true
    }
        
    override func animateOneFrame() 
    {
        let context = window!.graphicsContext
        NSGraphicsContext.setCurrentContext(context)
        
        if animState == "fade"
        {
            fadeOut()
        }
        else
        {
            if scene.isDone()
            {
                animState = "fade"
                fadeCount = 0
            }
            scene.nextStep()
        }
        
        context?.flushGraphics()
    }
    
    /*
      00000000   0000000   0000000    00000000
      000       000   000  000   000  000     
      000000    000000000  000   000  0000000 
      000       000   000  000   000  000     
      000       000   000  0000000    00000000
    */
    
    func fadeOut()
    {
        let fade = scene.doublePref("fade")

        if fadeCount >= Int(fade)
        {
            clear()
            scene.setup(self.preview, width:self.width(), height:self.height())
            animState = "anim"
            animationTimeInterval = 1.0 / scene.fps
        }
        else
        {
            var a = (1.0-(fade-10)/230.0)
            a = 0.002 + a * a * a * a * 0.2
            clear(NSColor(red: 0, green: 0, blue: 0, alpha:CGFloat(a)))
            
            fadeCount += 1
        }
    }

    func clear(color:NSColor = NSColor.blackColor())
    {
        color.set()
        drawRect(bounds)
    }
    
    override func drawRect(rect: NSRect)
    {
        let bPath:NSBezierPath = NSBezierPath(rect: rect)
        bPath.fill()
    }
    override func configureSheet() -> NSWindow? { return sheetController.window }
    override func hasConfigureSheet() -> Bool { return true }
    func width() -> Int { return Int(bounds.size.width) }
    func height() -> Int { return Int(bounds.size.height) }
}
