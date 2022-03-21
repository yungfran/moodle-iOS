//
//  SignUpViewController.swift
//  moodle
//
//  Created by Jessie on 3/12/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "finishedSignupSegue", sender: nil)
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
    
}
