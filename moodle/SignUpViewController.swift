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
    @IBOutlet var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a gradient layer.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "customGradient1")!.cgColor, UIColor(named: "customGradient2")!.cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.

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
    
}
