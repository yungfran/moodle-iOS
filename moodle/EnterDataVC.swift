//
//  EnterDataVC.swift
//  moodle
//
//  Created by Francis Tran on 3/9/22.
//

import Foundation
import UIKit

class EnterDataVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var QuestionButton: UIButton!
    
    @IBOutlet weak var userComments: UITextField!
    
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var currentNum: UILabel!
    
    let expandedViewIdentifier = "ExpandedEntrySegue"
    var picturesToAdd: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentNum.text = String(Int(ratingSlider.value))
    }
    
    @IBAction func changedSlider(_ sender: Any) {
        currentNum.text = String(Int(round(ratingSlider.value)))
    }
    
    @IBAction func clickQuestion(_ sender: Any) {
        let controller = UIAlertController(
            title: "Rating Your Mood",
            message: "Rate your overall mood for the day with a 1-10 scale, 1 being a bad day and feeling unhappy, and 10 being a good day and feeling happy.",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pressedSubmit(_ sender: Any) {
        //let user = getUsername()
        //let date = getDate()
        let rating:Int = Int(round(ratingSlider.value))
        let comments = userComments != nil ? userComments.text : ""
        
        
//        print("Rating: ", rating)
//        print("Comments: ", comments!)
//        print("Number of pictures: ", picturesToAdd.count)
        //Data.storeEntry(username: <#T##String#>, date: <#T##Date#>, rating: rating, detail: comments, images:picturesToAdd)
        //Segue to calendar view
    }
    
    // Called After "Choose" is pressed after an image has been selected / captured
    // Need to adjust info plst??
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picturesToAdd.append(pickedImage)
            self.dismiss(animated: true, completion: nil)
            print("Image Selected (Size: ",pickedImage.size,"); photo select dismissed")
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
        
        let uploadPhotoAction = UIAlertAction(title: "Upload Photo From Library", style: .default, handler: {_ in self.uploadPhotoHandler()})
        controller.addAction(uploadPhotoAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    // https://stackoverflow.com/questions/41717115/how-to-make-uiimagepickercontroller-for-camera-and-photo-library-at-the-same-tim
    func takePhotoHandler () {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func uploadPhotoHandler() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else  {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
