//
//  MoodleColors.swift
//  moodle
//
//  Created by Regina Chen on 3/19/22.
//

import UIKit

class MoodleColors {
    
    class var rating1: UIColor {
        return UIColorFromRGB(0xC97474)
    }
    
    class var rating2: UIColor {
        return UIColorFromRGB(0xFF8585)
    }
    
    class var rating3: UIColor {
        return UIColorFromRGB(0xFFB37B)
    }
    
    class var rating4: UIColor {
        return UIColorFromRGB(0xFFDA7B)
    }
    
    class var rating5: UIColor {
        return UIColorFromRGB(0xFCFF7E)
    }
    
    class var rating6: UIColor {
        return UIColorFromRGB(0xB28DFF)
    }
    
    class var rating7: UIColor {
        return UIColorFromRGB(0x7CB1FF)
    }
    
    class var rating8: UIColor {
        return UIColorFromRGB(0x80FFF7)
    }
    
    class var rating9: UIColor {
        return UIColorFromRGB(0xB9FF83)
    }
    
    class var rating10: UIColor {
        return UIColorFromRGB(0x81FF8D)
    }
}

// creates a UIColor from RGB values
func UIColorFromRGB(_ rgbValue: Int) -> UIColor! {
    return UIColor(
        red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
        green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
        blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
        alpha: 1.0)
}
