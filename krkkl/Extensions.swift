import AppKit

extension NSColor {
    
    func red()   -> CGFloat { return redComponent   }
    func green() -> CGFloat { return greenComponent }
    func blue()  -> CGFloat { return blueComponent  }
    
    func darken(factor: Float) -> NSColor {
        let f = CGFloat(factor)
        return NSColor(red: red()*f, green: green()*f, blue: blue()*f, alpha: 1)
    }
    
    func fadeTo(color:NSColor, fade:Float) -> NSColor {
        let r = CGFloat(red()   * CGFloat(1.0-fade) + CGFloat(fade) * color.red())
        let g = CGFloat(green() * CGFloat(1.0-fade) + CGFloat(fade) * color.green())
        let b = CGFloat(blue()  * CGFloat(1.0-fade) + CGFloat(fade) * color.blue())
        return NSColor(red: r, green: g, blue: b, alpha: 1)
    }
}
