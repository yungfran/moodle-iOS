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
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textColor = .black
    }
}
