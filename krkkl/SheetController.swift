import Cocoa

class SheetController : NSWindowController
{
    var defaults = Defaults()

    @IBOutlet var circleColorWell: NSColorWell?
    @IBOutlet var canvasColorWell: NSColorWell?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        canvasColorWell!.color = defaults.canvasColor
        circleColorWell!.color = defaults.circleColor
    }

    @IBAction func updateDefaults(sender: AnyObject)
    {
        defaults.canvasColor = canvasColorWell!.color
        defaults.circleColor = circleColorWell!.color
    }
   
    @IBAction func closeConfigureSheet(sender: AnyObject)
    {
        NSApp.endSheet(window!)
    }
    
    override var windowNibName: String!
        {
            return "ConfigureSheet"
    }
}
