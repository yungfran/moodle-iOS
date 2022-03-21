//
//  ExtendedDayVC.swift
//  moodle
//
//  Created by Regina Chen on 3/12/22.
//

import UIKit
import FSCalendar

class ExtendedDayVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    var selectedDate: Date?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var onDateLabel: UILabel!
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, y"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = formatter.string(from: selectedDate!)
        onDateLabel.text = "On \(formatter.string(from: selectedDate!)) you...."
    }
    

}
