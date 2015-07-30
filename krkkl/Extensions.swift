/*
  00000000  000   000  000000000  00000000  000   000   0000000  000   0000000   000   000   0000000
  000        000 000      000     000       0000  000  000       000  000   000  0000  000  000     
  0000000     00000       000     0000000   000 0 000  0000000   000  000   000  000 0 000  0000000 
  000        000 000      000     000       000  0000       000  000  000   000  000  0000       000
  00000000  000   000     000     00000000  000   000  0000000   000   0000000   000   000  0000000 
*/
import AppKit

extension NSColor {
    
    func red()   -> CGFloat { return redComponent   }
    func green() -> CGFloat { return greenComponent }
    func blue()  -> CGFloat { return blueComponent  }
    func alpha() -> CGFloat { return alphaComponent  }
    
    func darken(factor: Float) -> NSColor {
        let f = CGFloat(factor)
        return NSColor(red: red()*f, green: green()*f, blue: blue()*f, alpha: alpha())
    }
    
    func fadeTo(color:NSColor, fade:Float) -> NSColor {
        let r = CGFloat(red()   * CGFloat(1.0-fade) + CGFloat(fade) * color.red())
        let g = CGFloat(green() * CGFloat(1.0-fade) + CGFloat(fade) * color.green())
        let b = CGFloat(blue()  * CGFloat(1.0-fade) + CGFloat(fade) * color.blue())
        let a = CGFloat(alpha() * CGFloat(1.0-fade) + CGFloat(fade) * color.alpha())
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
}

func randint(n: Int) -> Int { return Int(arc4random_uniform(UInt32(n))) }
func randflt() -> Float { return Float(arc4random()) / Float(UINT32_MAX) }
func randdbl() -> Double { return Double(arc4random()) / Double(UINT32_MAX) }
func randfltrng(low:Float,high:Float) -> Float { return min(high, low) + abs(high-low) * randflt() }
func rest(v:Float) -> Float { return v-floor(v) }
func clamp(v:Float, low:Float, high:Float) -> Float { return max(low, min(v, high)) }
func colorRGB(rgb:[Float]) -> NSColor { return NSColor(red: CGFloat(rgb[0]), green:CGFloat(rgb[1]), blue:CGFloat(rgb[2]), alpha:CGFloat(rgb.count > 3 ? rgb[3] : 1)) }
func randColor() -> NSColor { return colorRGB([randflt(), randflt(), randflt()]) }
