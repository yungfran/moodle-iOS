//
//  SignUpViewController.swift
//  moodle
//
//  Created by Jessie on 3/12/22.
//

import UIKit
import FirebaseAuth
import SPAlert

class SignUpViewController: GradientViewController, UITextFieldDelegate {
    
    @IBOutlet weak var moodleImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.delegate = self
        emailField.delegate = self
        confirmPasswordField.delegate = self

        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                SPAlert.dismiss()
                self.performSegue(withIdentifier: "successfulSignupSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
        
        let darkModeStatus = defaults.bool(forKey: "darkMode")
        if darkModeStatus {
            moodleImage.image = UIImage(named: "moodleLogoWhite")
        } else {
            moodleImage.image = UIImage(named: "moodleLogoBlack")
        }
        
        emailField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.borderColor = UIColor.white.cgColor
        confirmPasswordField.layer.borderColor = UIColor.white.cgColor
        
        emailField.backgroundColor =  UIColor(named: "textFieldColor")
        passwordField.backgroundColor =  UIColor(named: "textFieldColor")
        confirmPasswordField.backgroundColor = UIColor(named: "textFieldColor")
        
        emailField.layer.cornerRadius = emailField.frame.size.height / 2
        //To apply border
        emailField.layer.borderWidth = 0.25
        
        //To apply Shadow
        emailField.layer.shadowOpacity = 1
        emailField.layer.shadowRadius = 3.0
        emailField.layer.shadowOffset = CGSize.zero // Use any CGSize
        emailField.layer.shadowColor = UIColor.gray.cgColor
        
        
        passwordField.layer.cornerRadius = passwordField.frame.size.height / 2
        //To apply border
        passwordField.layer.borderWidth = 0.25
        //To apply Shadow
        passwordField.layer.shadowOpacity = 1
        passwordField.layer.shadowRadius = 3.0
        passwordField.layer.shadowOffset = CGSize.zero // Use any CGSize
        passwordField.layer.shadowColor = UIColor.gray.cgColor
        
        
        confirmPasswordField.layer.cornerRadius = confirmPasswordField.frame.size.height / 2
        //To apply border
        confirmPasswordField.layer.borderWidth = 0.25
        //To apply Shadow
        confirmPasswordField.layer.shadowOpacity = 1
        confirmPasswordField.layer.shadowRadius = 3.0
        confirmPasswordField.layer.shadowOffset = CGSize.zero // Use any CGSize
        confirmPasswordField.layer.shadowColor = UIColor.gray.cgColor
        
        signUpButton.backgroundColor = UIColor(red: 0.409, green: 0.403, blue: 1.000, alpha: 0.8)
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
        signUpButton.layer.borderWidth = 0.25
        signUpButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if confirmPasswordField.text! == passwordField.text!{
            SPAlert.present(title: "Signing up", preset: .spinner)
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
                        authResult, error in
                        if let error = error as NSError? {
                            self.errorMessage.text = "\(error.localizedDescription)"
                            SPAlert.dismiss()
                            SPAlert.present(title: "Sign up failed", preset: .error)
                        } else {
                            self.errorMessage.text = ""
                        }
                    }
        } else {
            let controller = UIAlertController(title: "Password mismatch", message: "Please make sure your passwords match", preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(controller, animated: true, completion: nil)
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
