//
//  EnterDataVC.swift
//  moodle
//
//  Created by Francis Tran on 3/9/22.
//

import Foundation
import UIKit
import FirebaseAuth
import PhotosUI
import SPAlert

class EnterDataVC: GradientViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, PHPickerViewControllerDelegate {
    
    var userMoodRating : Int = -1
    let expandedViewIdentifier = "ExpandedEntrySegue"
    let cellIdentifier = "moodCell"
    var picturesToAdd: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.photosView.reloadData()
                self.attachPhotoLabel.setTitle("Attach photo(s): (\(self.picturesToAdd.count) currently selected)", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    /* Standard View Items */
    @IBOutlet weak var enterMoodLabel: UITextField!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var addMoreInfoButton: UIButton!
    @IBOutlet weak var enterMoodLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!
    
    /* Expanded View Items */
    @IBOutlet weak var userComments: UITextField!
//    @IBOutlet weak var attachPhotoLabel: UILabel!
//    @IBOutlet weak var attachPhotoButton: UIButton!
    
    @IBOutlet weak var attachPhotoLabel: UIButton!
    @IBOutlet weak var photosView: UICollectionView!
    
    @IBOutlet weak var addAdditionalInfoLabel: UILabel!
    @IBOutlet weak var sliderView: UICollectionView!     //y = 173 std, y = 372
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userComments.delegate = self
        picturesToAdd = []
        sliderView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        sliderView.delegate = self
        sliderView.dataSource = self
        
        photosView.delegate = self
        photosView.dataSource = self
        photosView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("here")
        datePicker.maximumDate = Date()
        submitButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 17)
        picturesToAdd = []
        photosView.reloadData()
        super.viewWillAppear(animated)
        expandedView(hidden:true) // Everytime the view appears, hide all the expanded stuff
        resetView()
    }
    
    @IBAction func clickQuestion(_ sender: Any) {
        let controller = UIAlertController(
            title: "Rating Your Mood",
            message: "Tap a circle to rate your overall mood for the day with a 1-10 scale, 1 being a bad day and feeling unhappy, and 10 being a good day and feeling happy.",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pressedSubmit(_ sender: Any) {
        if Auth.auth().currentUser != nil && userMoodRating != -1 {
            SPAlert.present(title: "Saving", preset: .spinner)
            guard let user = Auth.auth().currentUser?.email else { abort() }
            let date = datePicker.date
            for pic in picturesToAdd {
                print(pic.hash)
            }
            Data.storeEntry(username: user, date: date, rating: userMoodRating, detail: userComments.text, images: picturesToAdd)
            SPAlert.dismiss()
            SPAlert.present(title: "Success!", preset: .done)
            
        }
        
        if userMoodRating == -1 {
            let controller = UIAlertController(
                title: "Rate your mood",
                message: "Tap on a circle to select your mood",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        }
    }
    
    /* Functions for adding pictures */
    //     Called After "Choose" is pressed after an image has been selected / captured
    //     Need to adjust info plst??
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picturesToAdd.append(pickedImage)
            self.dismiss(animated: true, completion: nil)
            print("Image Selected (Size: ", pickedImage.size, "); photo select dismissed")
        }
    }
    
    @IBAction func attachPhoto(_ sender: Any) {
        let controller = UIAlertController(
            title: "Attach Photo",
            message: nil,
            preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        controller.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {_ in self.takePhotoHandler()})
        controller.addAction(takePhotoAction)
        
        let uploadPhotoAction = UIAlertAction(title: "Upload Photo From Library", style: .default, handler: {_ in self.uploadPhotos()})
        controller.addAction(uploadPhotoAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    func uploadPhotos() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if(results.count == 0){
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) {
                (url, error) in
                guard let coeUrl = url else { return }

                let data = NSData(contentsOf: coeUrl)!
                let image = UIImage(data: data as Foundation.Data)
                self.picturesToAdd.append(image!)
            }
        }
    }
    
    // https://stackoverflow.com/questions/41717115/how-to-make-uiimagepickercontroller-for-camera-and-photo-library-at-the-same-tim
    func takePhotoHandler () {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadPhotoHandler() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    /* End Photo Adding Functions*/
    
    /* Start Collection View Functions */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.sliderView {
            return 10 // Number of ratings
        } else {
            return picturesToAdd.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.sliderView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! MoodScoreCollectionCell
            
            cell.numberLabel.text = String(indexPath[1] + 1)
            cell.backgroundColor =  MoodleColors.moodleColorsList[indexPath[1]]
            cell.layer.masksToBounds = true
            cell.numberLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            cell.numberLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath as IndexPath) as! ImageCollectionViewCell
            let currPhoto = picturesToAdd[indexPath.row]
            cell.imageViewCell.image = currPhoto
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.sliderView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! MoodScoreCollectionCell
            userMoodRating = indexPath[1] + 1
            sliderView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.sliderView {
            if indexPath[1] + 1 == userMoodRating{

                //NSLayoutConstraint.activate(smallConstraints)
                return CGSize(width: 100, height: 100)
            }
            
           // NSLayoutConstraint.activate(smallConstraints)
            return CGSize(width: 75, height: 75)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    /* Called when we are about to display a cell*/
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.sliderView {
            let ourCell = cell as! MoodScoreCollectionCell
            if indexPath[1] + 1 == userMoodRating{
    //            let trans = CGAffineTransform(translationX: 10.0, y: 10.0)
    //            ourCell.numberLabel.transform = trans
                let screenLocPreMove = self.sliderView.convert(ourCell.frame.origin, to: self.view)
                let screenLoc = CGPoint(x:screenLocPreMove.x + 50,y:screenLocPreMove.y + 50)
                let pulse = PulseAnimation(numberOfPulse: 1, radius: 60, postion: screenLoc )
                pulse.animationDuration = 0.5
                pulse.backgroundColor =  #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                self.view.layer.insertSublayer(pulse, below: self.view.layer)
            }
        }
    }
    /* End Collection View Functions */
    
    /* Start Animations for switching between standard and expanded view*/
    
    // Negative for moving to expanded view so that they move up
    let sliderYChange = 200
    let enterMoodLabelYChange = 135
    let questionButtonYChange = 135
    
    let enterMoodLabelStartYPos = 185
    let questionButtonStartYPos = 247
    let sliderStartYPos = 345
    
    //Resets the positions of the "enter mood" label, question mark button, slider
    func resetView() {
        UIView.animate (
            withDuration: 0.0,
            animations: {
                let trans = CGAffineTransform(translationX:0, y: CGFloat(0))
                self.questionButton.transform = trans
            }
        )
        
//        cell.numberLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        
        //self.enterMoodLabel.removeConstraint(enterMoodLabelTopAnchor)
        UIView.animate (
            withDuration: 0.0,
            animations: {
                let trans = CGAffineTransform(translationX:0, y: CGFloat(0))
                self.enterMoodLabel.transform = trans
            }
        )
        
        
        UIView.animate(
            withDuration: 0.0,
            animations: {
                let trans = CGAffineTransform(translationX:0, y: CGFloat(0))
                self.sliderView.transform = trans
            }
        )
        
    }
    func fadeOutStandardView() {
//        enterMoodLabel.alpha = 1.0
//        questionButton.alpha = 1.0
//        addMoreInfoButton.alpha = 1.0
        
//        UIView.animate (
//            withDuration: 1.0,
//            animations: {
//                self.enterMoodLabel.alpha = 0.0
//            }
//        )
//
//        UIView.animate (
//            withDuration: 1.0,
//            animations: {
//                self.questionButton.alpha = 0.0
//            }
//        )
        
        UIView.animate (
            withDuration: 1.0,
            animations: {
                self.addMoreInfoButton.alpha = 0.0
            }
        )
    }
    
    func expandedView(hidden:Bool) {
        userComments.isHidden = hidden
        userComments.alpha = 0.0
        addAdditionalInfoLabel.isHidden = hidden
        addAdditionalInfoLabel.alpha = 0.0
//        attachPhotoLabel.isHidden = hidden
//        attachPhotoLabel.alpha = 0.0
//        attachPhotoButton.isHidden = hidden
//        attachPhotoButton.alpha = 0.0
        
        photosView.isHidden = hidden
        photosView.alpha = 0.0
        attachPhotoLabel.isHidden = hidden
        attachPhotoLabel.alpha = 0.0
    }
    
    func standardView(hidden:Bool) {
        questionButton.isHidden = hidden
        enterMoodLabel.isHidden = hidden
        addMoreInfoButton.isHidden = hidden
    }
    
    func fadeInExpandedView() {
        UIView.animate (
            withDuration: 2.0,
            animations: {
                self.userComments.alpha = 1.0
            }
        )
        
        UIView.animate (
            withDuration: 2.0,
            animations: {
                self.addAdditionalInfoLabel.alpha = 1.0
            }
        )
        
        UIView.animate (
            withDuration: 2.0,
            animations: {
                self.attachPhotoLabel.alpha = 1.0
            }
        )
        
        
        UIView.animate (
            withDuration: 2.0,
            animations: {
                self.photosView.alpha = 1.0
            }
        )
        
//
//        UIView.animate (
//            withDuration: 2.0,
//            animations: {
//                self.attachPhotoButton.alpha = 1.0
//            }
//        )
        
        UIView.animate (
            withDuration: 1.0,
            animations: {
                let trans = CGAffineTransform(translationX:0, y: CGFloat(-self.questionButtonYChange))
                self.questionButton.transform = trans
            }
        )
        
//        cell.numberLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        
        //self.enterMoodLabel.removeConstraint(enterMoodLabelTopAnchor)
        UIView.animate (
            withDuration: 1.0,
            animations: {
                let trans = CGAffineTransform(translationX:0, y: CGFloat(-self.enterMoodLabelYChange))
                self.enterMoodLabel.transform = trans
            }
        )
        
        UIView.animate(
            withDuration: 1.0,
            animations: {
                let trans = CGAffineTransform(translationX:0, y: CGFloat(-self.sliderYChange))
                self.sliderView.transform = trans
            }
        )
    }
    /* Start Animations for switching between standard and expanded view*/
    @IBAction func expandDataEntry(_ sender: Any) {
       // fadeOutStandardView() // Fades out the standard view
        expandedView(hidden:false) // unhides all expanded view, and makes their alpha values 0, ready for fading in
        fadeInExpandedView()
        
    }
    
    // Called when 'return' key pressed
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
