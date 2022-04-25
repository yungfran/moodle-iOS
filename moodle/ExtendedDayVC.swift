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
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var onDateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
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
        getCircle()
    }
    
    // get log detials about the entry
    func getDetails(){
        detailLabel.text = entry?.detail
    }
    
    //draws the circle with the mood color as the background
    // has a label with rating on top
    func getCircle(){
        let circleLayer = CAShapeLayer();
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: (view.frame.size.width/2)-50, y: 100, width: 100, height: 100)).cgPath;
        view.layer.insertSublayer(circleLayer, at: 0)
        let entryRating = entry?.rating
        circleLayer.fillColor = MoodleColors.moodleColorsList[Int(entryRating!) - 1].cgColor;
        ratingLabel.text = String(entryRating!)
    }
    
    //get log images
    func getImages(){
        images = entry?.images as! [UIImage]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
        let currPhoto = images[indexPath.row]
        cell.imageViewCell.image = currPhoto

        return cell
    }
    
    //make images expandable when tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let imageView = UIImageView(image: images[indexPath.row])
        imageView.frame = self.view.frame
        imageView.backgroundColor = .black
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)

        self.view.addSubview(imageView)
    }

    // Use to back from full mode
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
}
