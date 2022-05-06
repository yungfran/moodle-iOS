//
//  SettingsViewController.swift
//  moodle
//
//  Created by Tony Chang on 3/16/22.
//

import UIKit
import FirebaseAuth
import UserNotifications

class SettingsViewController: GradientViewController {
    @IBOutlet weak var darkModeToggle: UISwitch!
    @IBOutlet weak var notificationsToggle: UISwitch!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if defaults.object(forKey: "notificationsOn") == nil {
            defaults.set(false, forKey: "notificationsOn")
        }
        
        darkModeToggle.setOn(UserDefaults.standard.bool(forKey: "darkMode"), animated: true)
        notificationsToggle.setOn(UserDefaults.standard.bool(forKey: "notificationsOn"), animated: true)
        signOutButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 17)
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
        
        let notificationsKey = "notification"
        
        if notificationsToggle.isOn {
            defaults.set(true, forKey: "notificationsOn")
            let notification = UNMutableNotificationContent()
            notification.title = "Moodle"
            notification.body = "Don't forget to log today's mood!"
            
            var dt = DateComponents()
            dt.calendar = Calendar.current
            dt.hour = 17
            let trigger = UNCalendarNotificationTrigger(dateMatching: dt, repeats: true)
            
            let request = UNNotificationRequest(identifier: notificationsKey, content: notification, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                error in
                if error != nil {
                    print("ruh roh")
                }
            }
            
        } else {
            defaults.set(false, forKey: "notificationsOn")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
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
