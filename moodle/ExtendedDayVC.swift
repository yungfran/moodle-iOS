//
//  ExtendedDayVC.swift
//  moodle
//
//  Created by Regina Chen on 3/12/22.
//

import UIKit
import FSCalendar


class ExtendedDayVC: GradientViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "imageCell"
    var selectedDate: Date?
    var entry: Entry?
    var images: [UIImage] = []
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var onDateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    //create table of images??
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, y"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        dateLabel.text = formatter.string(from: selectedDate!)
        onDateLabel.text = "On \(formatter.string(from: selectedDate!)) you...."
        //aborts if nil
        entry = Data.retrieveData(username: "user", date: selectedDate!)!
        getLog()
    }
    
    func getLog(){
        getDetails()
        getImages()
    }
    
    func getDetails(){
        detailLabel.text = entry?.detail
    }
    
    func getImages(){
        images = entry?.images as! [UIImage]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
        cell.imageViewCell.image = images[indexPath.row]
        return cell
    }
    
}
