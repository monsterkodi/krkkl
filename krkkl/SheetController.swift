import Cocoa

class SheetController : NSWindowController
{
    var defaults = Defaults()
    var pageNumber = -1
    
    @IBOutlet var colorsPage: NSView?
    @IBOutlet var valuesPage: NSView?
    @IBOutlet var pages:      NSTabView?

//    @IBOutlet var circleColorWell: NSColorWell?
//    @IBOutlet var canvasColorWell: NSColorWell?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
//        canvasColorWell!.color = defaults.canvasColor
//        circleColorWell!.color = defaults.circleColor
    }

    @IBAction func showPage(sender: AnyObject)
    {
        if pageNumber != sender.selectedSegment
        {
            pageNumber = sender.selectedSegment
            println(pageNumber)

            pages?.selectTabViewItemAtIndex(pageNumber)
//            var page:NSView
//            
//            switch pageNumber
//            {
//            case 1:  page = colorsPage!
//            default: page = valuesPage!
//            }
//            
//            if pages?.subviews.count > 0
//            {
//                pages!.replaceSubview(pages?.subviews.first as! NSView, with: page)
//            }
//            else
//            {
//                pages!.addSubview(page)
//            }
        }
    }
    
    @IBAction func updateDefaults(sender: AnyObject)
    {
//        defaults.canvasColor = canvasColorWell!.color
//        defaults.circleColor = circleColorWell!.color
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
