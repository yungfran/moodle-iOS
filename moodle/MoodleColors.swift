//
//  MoodleColors.swift
//  moodle
//
//  Created by Regina Chen on 3/19/22.
//

import UIKit

class MoodleColors {
    
    var rating1: UIColor
    var rating2: UIColor
    var rating3: UIColor
    var rating4: UIColor
    var rating5: UIColor
    var rating6: UIColor
    var rating7: UIColor
    var rating8: UIColor
    var rating9: UIColor
    var rating10: UIColor
    
    init(){
        rating1 = UIColorFromRGB(0xC97474)
        rating2 = UIColorFromRGB(0xFF8585)
        rating3 = UIColorFromRGB(0xFFB37B)
        rating4 = UIColorFromRGB(0xFFDA7B)
        rating5 = UIColorFromRGB(0xFCFF7E)
        rating6 = UIColorFromRGB(0xB28DFF)
        rating7 = UIColorFromRGB(0x7CB1FF)
        rating8 = UIColorFromRGB(0x80FFF7)
        rating9 = UIColorFromRGB(0xB9FF83)
        rating10 = UIColorFromRGB(0x81FF8D)
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
