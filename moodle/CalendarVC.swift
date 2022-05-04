//
//  CalendarVC.swift
//  moodle
//
//  Created by Regina Chen on 3/10/22.
//

import UIKit
import FSCalendar
import FirebaseAuth

class CalendarVC: GradientViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    lazy var today = dateFormatter1.string(from: Date())
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.delegate = self
        calendar.dataSource = self
        calendar.placeholderType = .none
        // for create mock data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.reloadData()
    }
    
    lazy var borderRadius = [today: 0.5]
    lazy var fillDefaultColors = [today: UIColor.clear]
    
    // choose if calendar entries are circles or squares
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        let key = self.dateFormatter1.string(from: date)
        if let radius = self.borderRadius[key] {
            return radius
        }
        return appearance.borderRadius
    }
    
    // set fill/background color of each day
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if let color = getDateColor(givenDate: date) {
            return color
        } else {
            return UIColor.gray
        }
    }
    
    func getDateColor(givenDate: Date) -> UIColor? {
        
        guard let user = Auth.auth().currentUser?.email else { abort() }
        let entry = Data.retrieveData(username: user, date: givenDate)
        if let entryRating = entry?.rating{
            return MoodleColors.moodleColorsList[Int(entryRating) - 1]
        }
        return UIColor.gray
    }
    
    // when a circle is tapped
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("\(date) has been tapped")
        
        guard let user = Auth.auth().currentUser?.email else { abort() }
        if Data.retrieveData(username: user, date: date) != nil {
            self.performSegue(withIdentifier: "extendedDaySegue", sender: nil)
        } else {
            print("\(date) has been tapped but has no log")
        }
    }
    
    // when going back, sets the color of the day selected
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if let color = getDateColor(givenDate: date) {
            return color
        } else {
            return UIColor.gray
        }
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? ExtendedDayVC {
            nextVC.selectedDate = calendar.selectedDate
        }
    }
}
