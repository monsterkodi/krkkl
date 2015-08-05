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
    
    func darken(factor: Double) -> NSColor
    {
        let f = CGFloat(factor)
        return NSColor(red: red()*f, green: green()*f, blue: blue()*f, alpha: alpha())
    }

    func scale(factor: Double) -> NSColor
    {
        let f = CGFloat(factor)
        return NSColor(red: red()*f, green: green()*f, blue: blue()*f, alpha: alpha())
    }
    
    func fadeTo(color:NSColor, fade:Float) -> NSColor
    {
        let r = CGFloat(red()   * CGFloat(1.0-fade) + CGFloat(fade) * color.red())
        let g = CGFloat(green() * CGFloat(1.0-fade) + CGFloat(fade) * color.green())
        let b = CGFloat(blue()  * CGFloat(1.0-fade) + CGFloat(fade) * color.blue())
        let a = CGFloat(alpha() * CGFloat(1.0-fade) + CGFloat(fade) * color.alpha())
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func hex() -> String
    {
        return NSString(format: "#%x%x%x", Int(red()*255), Int(green()*255), Int(blue()*255)) as String
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
    func childWithIdentifier(identifier:String) -> NSView?
    {
        var child:NSView? = subviews.filter({ (e) -> Bool in
            return e.identifier == identifier
        }).first as? NSView
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
        var data = NSKeyedArchiver.archivedDataWithRootObject(self)
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSView
    }
}

/*
  00     00  000   0000000   0000000
  000   000  000  000       000     
  000000000  000  0000000   000     
  000 0 000  000       000  000     
  000   000  000  0000000    0000000
*/

func randint(n: Int) -> Int { return Int(arc4random_uniform(UInt32(n))) }
func randflt() -> Float { return Float(arc4random()) / Float(UINT32_MAX) }
func randdbl() -> Double { return Double(arc4random()) / Double(UINT32_MAX) }
func randdblrng(low:Double,high:Double) -> Double { return min(high, low) + abs(high-low) * randdbl() }
func randfltrng(low:Float,high:Float) -> Float { return min(high, low) + abs(high-low) * randflt() }
func randintrng(low:Int,high:Int) -> Int { return min(high, low) + randint(high-low) }
func rest(v:Float) -> Float { return v-floor(v) }
func clamp(v:Float, low:Float, high:Float) -> Float { return max(low, min(v, high)) }
func colorRGB(rgb:[Float]) -> NSColor { return NSColor(red: CGFloat(rgb[0]), green:CGFloat(rgb[1]), blue:CGFloat(rgb[2]), alpha:CGFloat(rgb.count > 3 ? rgb[3] : 1)) }
func randColor() -> NSColor { return colorRGB([randflt(), randflt(), randflt()]) }
func valueStep(value:Double, step:Double) -> Double { return floor(value/step)*step }
