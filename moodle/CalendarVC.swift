//
//  CalendarVC.swift
//  moodle
//
//  Created by Regina Chen on 3/10/22.
//

//TODO see if can shorten last week
import UIKit
import FSCalendar

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
    }
    
    lazy var borderDefaultColors = ["2022/03/03": UIColor.red, today: UIColor.black]
    let borderRadius = ["2022/03/03": 1.0]
    lazy var fillDefaultColors = [today: UIColor.clear]
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        
        let key = self.dateFormatter1.string(from: date)
        if let color = self.borderDefaultColors[key] {
            return color
        }
        return appearance.borderDefaultColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        let key = self.dateFormatter1.string(from: date)
        if let radius = self.borderRadius[key] {
            return radius
        }
        return appearance.borderRadius
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillDefaultColors[key] {
            return color
        } else {
            //let colors = MoodleColors()
            //return colors.rating2
            //return MoodleColors.rating5
            return MoodleColors.moodleColorsList[8]
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("\(date) has been tapped")
        self.performSegue(withIdentifier: "extendedDaySegue", sender: nil)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillDefaultColors[key] {
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
