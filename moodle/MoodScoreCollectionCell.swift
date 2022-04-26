//
//  moodScoreCollectionCell.swift
//  moodle
//
//  Created by Francis Tran on 4/9/22.
//

import UIKit

class MoodScoreCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    var labelTranslated = false
    
    override func draw(_ rect: CGRect) { //Your code should go here.
        super.draw(rect)
        self.layer.cornerRadius = self.frame.size.width / 2
        //numberLabel.textAlignment = .center
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textColor = .black
//        numberLabel.center = self.center
//        numberLabel.center.x = self.center.x
//        numberLabel.center.y = self.center.y
    }

    override var isSelected: Bool{
        didSet{
//            UIView.animate(withDuration: 0.1, animations: {
//                self.alpha = 0.0
//                // 27 top 16 left if size 75
//                // top cons 39, left cons 29 if size 100
//                self.numberLabel.center.x += 30
//                self.numberLabel.center.y += 30
//            }, completion: nil)
        }
    }
}
