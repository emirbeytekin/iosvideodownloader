import UIKit

enum FontStyle {
    case fontStyleBlack
    case fontStyleBlackOblique
    case fontStyleBook
    case fontStyleBookOblique
    case fontStyleHeavy
    case fontStyleHeavyOblique
    case fontStyleLight
    case fontStyleLightOblique
    case fontStyleMedium
    case fontStyleMediumOblique
    case fontStyleOblique
    case fontStyleRoman
}

extension UIFont {
    
    static func fontWithSize(_ fontSize: CGFloat, style: FontStyle) -> UIFont {
        
        var suffix:String?
        
        if style == FontStyle.fontStyleBlack {
            suffix = "-Black"
        } else if style == FontStyle.fontStyleBlackOblique {
            suffix = "-BlackOblique"
        } else if style == FontStyle.fontStyleBook {
            suffix = "-Book"
        } else if style == FontStyle.fontStyleBookOblique {
            suffix = "-BookOblique"
        } else if style == FontStyle.fontStyleHeavy {
            suffix = "-Heavy"
        } else if style == FontStyle.fontStyleHeavyOblique {
            suffix = "-HeavyOblique"
        } else if style == FontStyle.fontStyleLight {
            suffix = "-Light"
        } else if style == FontStyle.fontStyleLightOblique {
            suffix = "LightOblique"
        } else if style == FontStyle.fontStyleMedium {
            suffix = "-Medium"
        } else if style == FontStyle.fontStyleMediumOblique {
            suffix = "-MediumOblique"
        } else if style == FontStyle.fontStyleOblique {
            suffix = "-Oblique"
        } else if style == FontStyle.fontStyleRoman {
            suffix = "-Roman"
        } else {
            suffix = ""
        }
        
        let fontName = "Avenir"+suffix!
        
        let font = UIFont(name: fontName, size: fontSize)
        
        return font!
    }
    
}

// ========================================
// FONT SIZE INFO:
// ========================================
/*
 Button
 Text - Ubuntu Medium - 14 px
 Size - Width 270 px, Height 35 px, Radius 3 px, x 25px
 
 Text Field
 Text - Ubuntu Regular - 13 px
 Size - Width 270 px, Height 35 px, Radius 3 px, x 25px(edited)
 */



// ========================================
// MARK: APPLICATION FONTS
// ========================================


extension UIFont{
    
    static func navigationBarFont()->UIFont{
        return UIFont.fontWithSize(16, style: FontStyle.fontStyleMedium)
    }
    
}
