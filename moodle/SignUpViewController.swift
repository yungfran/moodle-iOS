//
//  SignUpViewController.swift
//  moodle
//
//  Created by Jessie on 3/12/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: GradientViewController, UITextFieldDelegate {
    
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
                self.performSegue(withIdentifier: "successfulSignupSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if confirmPasswordField.text! == passwordField.text!{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
                        authResult, error in
                        if let error = error as NSError? {
                            self.errorMessage.text = "\(error.localizedDescription)"
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
