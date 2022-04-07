//
//  GradientViewController.swift
//  moodle
//
//  Created by Tony Chang on 3/31/22.
//

import UIKit

class GradientViewController: UIViewController {

    //static var darkMode = false
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
        gradientLayer.colors = [UIColor(named: "customGradient1")!.cgColor, UIColor(named: "customGradient2")!.cgColor]
        gradientLayer.shouldRasterize = true
        view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let darkModeStatus = defaults.bool(forKey: "darkMode")
        if darkModeStatus {
            gradientLayer.removeFromSuperlayer()
            overrideUserInterfaceStyle = .dark
            // Create a gradient layer.
            
            gradientLayer.colors = [UIColor(red: 0.271, green: 0.263, blue: 0.576, alpha: 1.0).cgColor, UIColor(red: 0.306, green: 0.075, blue: 0.486, alpha: 1.0).cgColor]
            //gradientLayer.colors = [UIColor(named: "customGradient1")!.cgColor, UIColor(named: "customGradient2")!.cgColor]
            gradientLayer.shouldRasterize = true
            view.layer.insertSublayer(gradientLayer, at: 0)

        } else if !darkModeStatus {
            gradientLayer.removeFromSuperlayer()
            overrideUserInterfaceStyle = .light
            // Create a gradient layer.
            gradientLayer.colors = [UIColor(named: "customGradient1")!.cgColor, UIColor(named: "customGradient2")!.cgColor]
            gradientLayer.shouldRasterize = true
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func setDarkMode() {
        defaults.set(true, forKey: darkModeKey)
        //GradientViewController.darkMode = true
    }
    
    func setLightMode() {
        defaults.set(false, forKey: darkModeKey)
        //GradientViewController.darkMode = false
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
