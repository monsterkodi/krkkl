import Cocoa

class ColorCell : NSTextFieldCell
{
    override func drawWithFrame(rect:NSRect, inView: NSView)
    {
        super.drawWithFrame(rect, inView:inView)
        //    [NSGraphicsContext saveGraphicsState];
        //
        //    [[self backgroundColor] set];
        //    NSRectFill(rect);
        //
        //    [[self textColor] set];
        //    NSRect square = rect;
        //    square.size.width = square.size.height;
        //    square = NSInsetRect(square, 2, 2);
        //    square.origin.x += 1;
        //    NSRectFill(square);
        //
        //    rect.origin.x += 25;
        //
        //    NSMutableAttributedString * str = [NSMutableAttributedString withString:[self title]];
        //    [str setColor:[self textColor]];
        //    [str addAttribute:NSFontAttributeName value:[self font] range:[str range]];
        //    [str drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine];
        //    
        //    [NSGraphicsContext restoreGraphicsState];
    }
}
