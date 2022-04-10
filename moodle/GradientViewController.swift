//
//  GradientViewController.swift
//  moodle
//
//  Created by Tony Chang on 3/31/22.
//

import UIKit

class GradientViewController: UIViewController {

    var gradientLayer = CAGradientLayer()
    let darkMode = false
    let darkModeKey = "darkMode"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.object(forKey: darkModeKey) == nil {
            defaults.set(darkMode, forKey: darkModeKey)
        }
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let darkModeStatus = defaults.bool(forKey: "darkMode")
        gradientLayer.removeFromSuperlayer()
        
        if darkModeStatus {
            overrideUserInterfaceStyle = .dark
            gradientLayer.colors = [UIColor(red: 0.271, green: 0.263, blue: 0.576, alpha: 1.0).cgColor, UIColor(red: 0.306, green: 0.075, blue: 0.486, alpha: 1.0).cgColor]

        } else {
            overrideUserInterfaceStyle = .light
            gradientLayer.colors = [UIColor(named: "customGradient1")!.cgColor, UIColor(named: "customGradient2")!.cgColor]
        }
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setDarkMode() {
        defaults.set(true, forKey: darkModeKey)
    }
    
    func setLightMode() {
        defaults.set(false, forKey: darkModeKey)
    }

}
