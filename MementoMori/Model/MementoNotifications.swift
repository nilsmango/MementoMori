//
//  MementoNotifications.swift
//  MementoMori
//
//  Created by Simon Lang on 27.02.23.
//

import Foundation
import UserNotifications

class MementoNotifications {
    
    let randomQuotes = ["It's later than you think", "Waste no more time arguing what a good man should be. Be One. – Marcus Aurelius", "It never ceases to amaze me: we all love ourselves more than other people, but care more about their opinion than our own. – Marcus Aurelius", "If a man knows not which port he sails, no wind is favorable. - Seneca", "We are more often frightened than hurt; and we suffer more in imagination than in reality. – Seneca", "I begin to speak only when I’m certain what I’ll say isn’t better left unsaid. – Cato", "How long are you going to wait before you demand the best for yourself? – Epictetus"]
    
    
    func scheduleMemento(quote: Bool, start: Int, end: Int, schedule: MementoSchedule) {
        let center = UNUserNotificationCenter.current()
        
        // request permission first
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            
            if let error = error {
                print("Error notification authorization: \(error)")
            }
            
            print("Authorization granted")
            // Enable or disable features based on the authorization.
        }
        
        
        center.removeAllPendingNotificationRequests()
        
        // scheduling 30 years of notifications
        
        var rangeOfNotifications = 1...100
        var calendarValue = 1
        var addingStep: Calendar.Component = .day
        
        switch schedule {
        case .daily:
            addingStep = .day
            calendarValue = 1
            rangeOfNotifications = 1...12000
        case .twice:
            addingStep = .day
            calendarValue = 1
            rangeOfNotifications = 1...12000
        case .weekly:
            addingStep = .day
            calendarValue = 7
            rangeOfNotifications = 1...1560
        case .monthly:
            addingStep = .month
            calendarValue = 1
            rangeOfNotifications = 1...360
        case .never:
            rangeOfNotifications = 0...0
            calendarValue = 0
        }
        
                for notificationNumber in rangeOfNotifications {
                    
                    func addingNotificationRequest(_ addingStep: Calendar.Component, _ calendarValue: Int, _ notificationNumber: ClosedRange<Int>.Element, _ start: Int, _ end: Int, _ center: UNUserNotificationCenter) {
                        let randomIndex = Int.random(in: 0..<randomQuotes.count)
                        let quote = randomQuotes[randomIndex]
                        
                        let content = UNMutableNotificationContent()
                        content.title = "Memento Mori"
                        content.body = quote
                        content.sound = UNNotificationSound.default
                        content.categoryIdentifier = "reminder"
                        
                        var dateComponents = DateComponents()
                        let startDate = Date.now
                        let endDate = Calendar.current.date(byAdding: addingStep, value: calendarValue * notificationNumber, to: startDate)!
                        
                        
                        
                        dateComponents.day = Calendar.current.dateComponents([.day], from: endDate).day
                        dateComponents.hour = .random(in: start..<end)
                        dateComponents.minute = .random(in: 0...59)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                        
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        center.add(request)
                        
                        if notificationNumber < 20 {
                            print(dateComponents)
                        }
                    }
                    
                    addingNotificationRequest(addingStep, calendarValue, notificationNumber, start, end, center)
                    
                    if schedule == .twice {
                        
                        addingNotificationRequest(addingStep, calendarValue, notificationNumber, start, end, center)

                }
            }
    }
}
