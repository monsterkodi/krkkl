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
    var animState:String = "anim"
    var fadeCount:Int = 0
    var scene:Cubes

    override init(frame: NSRect, isPreview: Bool) 
    {
        scene = Cubes()
        super.init(frame: frame, isPreview: isPreview)
        scene.view = self
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        scene = Cubes()
        super.init(coder: aDecoder)
        scene.view = self
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
        scene.setup()
        super.startAnimation()
        setAnimationTimeInterval(1.0 / scene.fps)
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
        if fadeCount >= 100
        {
            clear()
            scene.setup()
            animState = "anim"
        }
        else
        {
            clear(color:NSColor(red: 0, green: 0, blue: 0, alpha: 0.025))
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
        var bPath:NSBezierPath = NSBezierPath(rect: rect)
        bPath.fill()
    }
    
    override func hasConfigureSheet() -> Bool { return false }
    func width() -> Int { return Int(bounds.size.width) }
    func height() -> Int { return Int(bounds.size.height) }
}
