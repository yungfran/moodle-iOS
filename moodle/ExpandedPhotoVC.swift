//
//  ExpandedPhotoVC.swift
//  moodle
//
//  Created by Regina Chen on 5/3/22.
//

import UIKit

class ExpandedPhotoVC: UIViewController {
    
    var selectedPhoto: UIImage?
    
    @IBOutlet weak var expandedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expandedImageView.frame = self.view.frame
        expandedImageView.contentMode = .scaleAspectFit
        expandedImageView.image = selectedPhoto
    }
    

}
