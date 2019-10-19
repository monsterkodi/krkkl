/*
  00000000  000   000  000000000  00000000  000   000   0000000  000   0000000   000   000   0000000
  000        000 000      000     000       0000  000  000       000  000   000  0000  000  000     
  0000000     00000       000     0000000   000 0 000  0000000   000  000   000  000 0 000  0000000 
  000        000 000      000     000       000  0000       000  000  000   000  000  0000       000
  00000000  000   000     000     00000000  000   000  0000000   000   0000000   000   000  0000000 
*/
import AppKit

/*
   0000000   0000000   000       0000000   00000000 
  000       000   000  000      000   000  000   000
  000       000   000  000      000   000  0000000  
  000       000   000  000      000   000  000   000
   0000000   0000000   0000000   0000000   000   000
*/

extension NSColor
{
    func red()   -> CGFloat { return redComponent   }
    func green() -> CGFloat { return greenComponent }
    func blue()  -> CGFloat { return blueComponent  }
    func alpha() -> CGFloat { return alphaComponent }

    func r()    -> Float { return Float(redComponent)   }
    func g()    -> Float { return Float(greenComponent) }
    func b()    -> Float { return Float(blueComponent)  }

    func scale(_ factor: Double) -> NSColor
    {
        let f = CGFloat(factor)
        let r = cgclamp(red()*f,low: 0.0,high: 1.0)
        let g = cgclamp(green()*f, low: 0.0, high: 1.0)
        let b = cgclamp(blue()*f,low: 0.0,high: 1.0)
        return NSColor(red: r, green: g, blue: b, alpha: alpha())
    }
    
    func fadeTo(_ color:NSColor, fade:Float) -> NSColor
    {
        let r = CGFloat(red()   * CGFloat(1.0-fade) + CGFloat(fade) * color.red())
        let g = CGFloat(green() * CGFloat(1.0-fade) + CGFloat(fade) * color.green())
        let b = CGFloat(blue()  * CGFloat(1.0-fade) + CGFloat(fade) * color.blue())
        let a = CGFloat(alpha() * CGFloat(1.0-fade) + CGFloat(fade) * color.alpha())
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func hex() -> String
    {
        return NSString(format: "#%02x%02x%02x", Int(red()*255), Int(green()*255), Int(blue()*255)) as String
    }
}

/*
  000   000  000  00000000  000   000
  000   000  000  000       000 0 000
   000 000   000  0000000   000000000
     000     000  000       000   000
      0      000  00000000  00     00
*/

extension NSView
{
    func childWithIdentifier(_ identifier:String) -> NSView?
    {
        var child:NSView? = subviews.filter({ (e) -> Bool in
            return convertFromOptionalNSUserInterfaceItemIdentifier(e.identifier) == identifier
        }).first
        if (child != nil) { return child }
        for subview in subviews
        {
            child = subview.childWithIdentifier(identifier)
            if (child != nil)
            {
                return child
            }
        }
        return nil
    }
    
    func clone() -> NSView
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! NSView
    }
}

extension String
{
    func substring(_ start:Int, _ length:Int) -> String
    {
        return self.substring(with: (characters.index(startIndex, offsetBy: start) ..< characters.index(startIndex, offsetBy: start+length)))
    }
}

/*
  00     00  000   0000000   0000000
  000   000  000  000       000     
  000000000  000  0000000   000     
  000 0 000  000       000  000     
  000   000  000  0000000    0000000
*/

func randint(_ n: Int) -> Int { return Int(arc4random_uniform(UInt32(n))) }
func randflt() -> Float { return Float(arc4random()) / Float(UINT32_MAX) }
func randdbl() -> Double { return Double(arc4random()) / Double(UINT32_MAX) }
func randdblrng(_ low:Double,high:Double) -> Double { return min(high, low) + abs(high-low) * randdbl() }
func randfltrng(_ low:Float,high:Float) -> Float { return min(high, low) + abs(high-low) * randflt() }
func randintrng(_ low:Int,high:Int) -> Int { return min(high, low) + randint(high-low) }
func rest(_ v:Float) -> Float { return v-floor(v) }
func clamp(_ v:Float, low:Float, high:Float) -> Float { return max(low, min(v, high)) }
func cgclamp(_ v:CGFloat, low:CGFloat, high:CGFloat) -> CGFloat { return max(low, min(v, high)) }
func colorRGB(_ rgb:[Float]) -> NSColor { return NSColor(red: CGFloat(rgb[0]), green:CGFloat(rgb[1]), blue:CGFloat(rgb[2]), alpha:CGFloat(rgb.count > 3 ? rgb[3] : 1)) }
func randColor() -> NSColor { return colorRGB([randflt(), randflt(), randflt()]) }
func valueStep(_ value:Double, step:Double) -> Double { return floor(value/step)*step }

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalNSUserInterfaceItemIdentifier(_ input: NSUserInterfaceItemIdentifier?) -> String? {
	guard let input = input else { return nil }
	return input.rawValue
}
