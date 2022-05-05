//
//  LoginSignUpViewController.swift
//  moodle
//
//  Created by Jessie on 3/11/22.
//

import UIKit
import FirebaseAuth
import SPAlert

@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}


class LoginViewController: GradientViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var moodleImage: UIImageView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.delegate = self
        emailField.delegate = self
        
        let darkModeStatus = defaults.bool(forKey: "darkMode")
        if darkModeStatus {
            moodleImage.image = UIImage(named: "moodleLogoWhite")
        } else {
            moodleImage.image = UIImage(named: "moodleLogoBlack")
        }
        
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                SPAlert.dismiss()
                self.performSegue(withIdentifier: "successfulLoginSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
        
        emailField.backgroundColor = UIColor(named: "textFieldColor")
        emailField.layer.cornerRadius = emailField.frame.size.height / 2
        //To apply border
        emailField.layer.borderWidth = 0.25
        emailField.layer.borderColor = UIColor.white.cgColor
        //To apply Shadow
        emailField.layer.shadowOpacity = 1
        emailField.layer.shadowRadius = 3.0
        emailField.layer.shadowOffset = CGSize.zero // Use any CGSize
        emailField.layer.shadowColor = UIColor.gray.cgColor
        
        passwordField.backgroundColor = UIColor(named: "textFieldColor")
        passwordField.layer.cornerRadius = passwordField.frame.size.height / 2
        //To apply border
        passwordField.layer.borderWidth = 0.25
        passwordField.layer.borderColor = UIColor.white.cgColor
        //To apply Shadow
        passwordField.layer.shadowOpacity = 1
        passwordField.layer.shadowRadius = 3.0
        passwordField.layer.shadowOffset = CGSize.zero // Use any CGSize
        passwordField.layer.shadowColor = UIColor.gray.cgColor
        
        loginButton.backgroundColor = UIColor(red: 0.409, green: 0.403, blue: 1.000, alpha: 0.8)
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.layer.borderWidth = 0.25
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        SPAlert.present(title: "Logging in", preset: .spinner)
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {
            authResult, error in
            if let error = error as NSError? {
                self.errorMessage.text = "\(error.localizedDescription)"
                SPAlert.dismiss()
                SPAlert.present(title: "Login failed", preset: .error)
            } else {
                self.errorMessage.text = ""
            }
        }
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
