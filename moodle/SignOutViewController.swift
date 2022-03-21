//
//  SignOutViewController.swift
//  moodle
//
//  Created by Jessie on 3/12/22.
//

import UIKit
import FirebaseAuth

class SignOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
        } catch {
            print("Sign out error")
        }
    }

}
