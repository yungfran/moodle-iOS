//
//  SettingsViewController.swift
//  moodle
//
//  Created by Tony Chang on 3/16/22.
//

import UIKit
import FirebaseAuth

class SettingsViewController: GradientViewController {
    @IBOutlet weak var darkModeToggle: UISwitch!
    @IBOutlet weak var notificationsToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        darkModeToggle.setOn(false, animated: true)
    }
    
    @IBAction func darkModeToggleChanged(_ sender: Any) {
        if darkModeToggle.isOn {
            super.setDarkMode()
        } else {
            super.setLightMode()
        }
        super.viewWillAppear(false)
        
    }
    @IBAction func notificationsToggleChanged(_ sender: Any) {
        // TODO
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
        } catch {
            print("Sign out error")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
