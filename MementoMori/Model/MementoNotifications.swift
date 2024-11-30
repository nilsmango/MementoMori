//
//  MementoNotifications.swift
//  MementoMori
//
//  Created by Simon Lang on 27.02.23.
//

import Foundation
import UserNotifications

class MementoNotifications {
    
    func loadQuotes() -> [String] {
        guard let url = Bundle.main.url(forResource: "stoics", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(QuotesData.self, from: data)
            return decodedData.quotes
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
    
    let center = UNUserNotificationCenter.current()
    
    
//    func showNextMemento() -> String {
//
//        print(center.getPendingNotificationRequests(completionHandler: { error in
//                // error handling here
//            }))
//
//        var notificationDateString = ""
//        var numberOfNotifications = 0
//        center.getPendingNotificationRequests(completionHandler:  { notifications in
//            let number = notifications.count
//            let nextNotification = notifications.first
//            let notificationDate = nextNotification?.trigger as? UNCalendarNotificationTrigger
//            let nextTriggerDate = notificationDate?.nextTriggerDate()
//            let formatter1 = DateFormatter()
//            formatter1.dateStyle = .short
//            notificationDateString = formatter1.string(from: nextTriggerDate!)
//            numberOfNotifications = number
//        })
//        return notificationDateString + String(numberOfNotifications)
//    }
    
    
    func scheduleMemento(active: Bool, mementoText: String, quote: Bool, start: Int, end: Int, schedule: MementoSchedule) {
        print("Starting scheduling")
        
        // request permission first
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            
            if let error = error {
                print("Error notification authorization: \(error)")
            }
            
            print("Authorization granted")
            // Enable or disable features based on the authorization.
        }
        
        center.removeAllPendingNotificationRequests()
        
        if active {
            // scheduling yearly random notifications
            var randomTimes: [[String: Int]]
            
            // Generate random times for each day of the year
            // Use an array to ensure correct month-day mapping
            let daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
            
            randomTimes = daysInMonths.enumerated().flatMap { (monthIndex, daysInMonth) in
                (1...daysInMonth).map { day in
                    [
                        "month": monthIndex + 1,
                        "day": day,
                        "hour": .random(in: start..<end),
                        "minute": Int.random(in: 0...59)
                    ]
                }
            }
                if schedule == .twice {
                    let secondTimes = daysInMonths.enumerated().flatMap { (monthIndex, daysInMonth) in
                        (1...daysInMonth).map { day in
                            [
                                "month": monthIndex + 1,
                                "day": day,
                                "hour": .random(in: start..<end),
                                "minute": Int.random(in: 0...59)
                            ]
                        }
                }
                    randomTimes += secondTimes
            }
            
            let quotes = loadQuotes()
            let numberToRemainInOrder = 26
            let first26Quotes = Array(quotes.prefix(numberToRemainInOrder))
            let restQuotes = Array(quotes.dropFirst(numberToRemainInOrder))
            let randomQuotes = first26Quotes + restQuotes.shuffled()
            let randomQuoteCount = randomQuotes.count
            
            for (index, timeDict) in randomTimes.enumerated() {
                let quote: String
                if index < randomQuoteCount {
                    quote = randomQuotes[index]
                } else {
                    quote = randomQuotes.randomElement()!
                }
                
                let content = UNMutableNotificationContent()
                content.title = mementoText
                content.body = quote
                content.sound = UNNotificationSound.default
                content.categoryIdentifier = "reminder"
                
                var dateComponents = DateComponents()
                dateComponents.month = timeDict["month"]
                dateComponents.day = timeDict["day"]
                dateComponents.hour = timeDict["hour"]
                dateComponents.minute = timeDict["minute"]
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request)
            }
        }
    }
}
