//
//  Data.swift
//  moodle
//
//  Created by Tony Chang on 3/17/22.
//

import Foundation
import UIKit
import CoreData
import FirebaseAuth

class Data {
    
    static func storeEntrySync(username: String, date: Date, rating: Int, detail: String?, images: [UIImage]?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let alreadyExisting = retrieveData(username: username, date: date)
        let fg = appDelegate.persistentContainer.viewContext
        
        fg.performAndWait {
            if alreadyExisting != nil {
                alreadyExisting!.rating = Int16(rating)
                alreadyExisting!.detail = detail
                alreadyExisting!.images = images as NSObject?

                do {
                    try fg.save()
                    print("Updated entry for user: \(username) on date \(date)")
                    
                } catch let error as NSError {
                    NSLog("\(error)")
                    abort()
                }
            } else {
                let entry = Entry(context: fg)
                entry.username = username
                entry.date = date
                entry.rating = Int16(rating)
                entry.detail = detail
                entry.images = images as NSObject?

                do {
                    try fg.save()
                    print("Created entry for user: \(username) on date \(date)")
                    
                } catch let error as NSError {
                    NSLog("\(error)")
                    abort()
                }
            }
        }
        
    }
    
    static func storeEntry(username: String, date: Date, rating: Int, detail: String?, images: [UIImage]?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let alreadyExisting = retrieveData(username: username, date: date)
        
        let bg = appDelegate.persistentContainer.newBackgroundContext()
        
        bg.perform {
            if alreadyExisting != nil {
                alreadyExisting!.rating = Int16(rating)
                alreadyExisting!.detail = detail
                alreadyExisting!.images = images as NSObject?

                do {
                    try bg.save()
                    print("Updated entry for user: \(username) on date \(date)")
                    
                } catch let error as NSError {
                    NSLog("\(error)")
                    abort()
                }
            } else {
                let entry = Entry(context: bg)
                entry.username = username
                entry.date = date
                entry.rating = Int16(rating)
                entry.detail = detail
                entry.images = images as NSObject?

                do {
                    try bg.save()
                    print("Created entry for user: \(username) on date \(date)")
                    
                } catch let error as NSError {
                    NSLog("\(error)")
                    abort()
                }
            }
        }
    }
    
    static func retrieveData(username: String) -> [Entry] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        var fetched: [Entry]?
        
        let userPredicate = NSPredicate(format: "username = %@", username)
        request.predicate = userPredicate
        
        do {
            try fetched = context.fetch(request)
        } catch let error as NSError {
            NSLog("\(error)")
            abort()
        }
        return fetched!
    }
    
    static func retrieveData(username: String, beginning: String, end: String) -> [Entry] {
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        var actualBeginning = dateFormatter.date(from: beginning)!
        actualBeginning = calendar.startOfDay(for: actualBeginning)
        var actualEnd = dateFormatter.date(from: end)!
        actualEnd = calendar.startOfDay(for: actualEnd)
        
        return retrieveData(username: username, beginning: actualBeginning, end: actualEnd)
    }
    
    static func retrieveData(username: String, date: String) -> Entry? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let actual = dateFormatter.date(from: date)!

        let dateFrom = calendar.startOfDay(for: actual)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)

        let fetched = retrieveData(username: username, beginning: dateFrom, end: dateTo!)
        
        if fetched.count > 1 {
            NSLog("Somehow have more than one entry per day per user, should not be possible!")
            abort()
        }
        if fetched.count == 0 {
            return nil
        }
        return fetched[0]
    }
    
    static func retrieveData(username: String, date: Date) -> Entry? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)

        let fetched = retrieveData(username: username, beginning: dateFrom, end: dateTo!)
        
        if fetched.count > 1 {
            NSLog("Somehow have more than one entry per day per user, should not be possible!")
            abort()
        }
        if fetched.count == 0 {
            return nil
        }
        return fetched[0]
    }
    
    static func retrieveData(username: String, beginning: Date, end: Date) -> [Entry] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        var fetched: [Entry]?
        guard let user = Auth.auth().currentUser?.email else { abort() }
        let startPredicate = NSPredicate(format: "date >= %@", beginning as NSDate)
        let endPredicate = NSPredicate(format: "date < %@", end as NSDate)
        let userPredicate = NSPredicate(format: "username = %@", user)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [startPredicate, endPredicate, userPredicate])

        request.predicate = compound
        
        do {
            try fetched = context.fetch(request)
        } catch let error as NSError {
            NSLog("\(error)")
            abort()
        }
        return fetched!
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

class Mock {
    private static func datesRange(from: Date, to: Date) -> [Date] {
        if from > to {
            return [Date]()
        }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate <= to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    static func clearData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            NSLog("Error deleting all entries: \(error)")
            abort()
        }
        context.reset()
    }
    
    static func generateData() {
        let cur = Date()
        let start = Calendar.current.date(byAdding: .day, value: -100, to: cur)!
        let end = Calendar.current.date(byAdding: .day, value: -3, to: cur)!
        let range = Mock.datesRange(from: start, to: end)
        
        for date in range {
            let rating = Int.random(in: 1..<11)
            
            var images: [UIImage] = []
            images.append(UIColor.red.image(CGSize(width: 200, height: 200)))
            images.append(UIColor.blue.image(CGSize(width: 200, height: 200)))
            guard let user = Auth.auth().currentUser?.email else { abort() }
            
            Data.storeEntrySync(username: user, date: date, rating: rating, detail: "Lorem ipsum", images: images)
        }
    }
}
