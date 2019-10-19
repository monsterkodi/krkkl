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
    var scene:Cubes = Cubes()

    override init(frame: NSRect, isPreview: Bool) 
    {
        super.init(frame: frame, isPreview: isPreview)!
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    /*
       0000000   000   000  000  00     00
      000   000  0000  000  000  000   000
      000000000  000 0 000  000  000000000
      000   000  000  0000  000  000 0 000
      000   000  000   000  000  000   000
    */

    func restart()
    {
        var presets = sheetController.defaults.presets
        scene.preset = presets[randint(presets.count)]
        scene.setup(isPreview, width: self.width(), height: self.height())
  }
    
    override func startAnimation()
    {
        var presets = sheetController.defaults.presets
        scene.preset = presets[randint(presets.count)]
        scene.setup(self.isPreview, width: self.width(), height: self.height())
        super.startAnimation()
        animationTimeInterval = 1.0 / scene.fps
        self.window?.backingType = .nonretained // an attempt to stop the double-buffering, which doesn't work
    }
        
    override public func draw(_ rect: NSRect) {
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
            else
            {
                scene.nextStep()
            }
        }
    }

    override public func animateOneFrame() {
        needsDisplay = true
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
            scene.preset = sheetController.defaults.presets[randint(sheetController.defaults.presets.count)]
            scene.setup(self.isPreview, width:self.width(), height:self.height())
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

    func clear(_ color:NSColor = NSColor.black)
    {
        color.set()
        draw(bounds)
    }
    
    override var configureSheet: NSWindow? { return sheetController.window }
    override var hasConfigureSheet: Bool { return true }
    override var isOpaque: Bool { return true } // stop the window from drawing its background all the time
    func width() -> Int { return Int(bounds.size.width) }
    func height() -> Int { return Int(bounds.size.height) }
}
