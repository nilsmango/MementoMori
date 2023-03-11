//
//  MementoNotifications.swift
//  MementoMori
//
//  Created by Simon Lang on 27.02.23.
//

import Foundation
import UserNotifications

class MementoNotifications {
    
    let randomQuotes = ["It's later than you think", "Waste no more time arguing what a good man should be. Be One. – Marcus Aurelius", "It never ceases to amaze me: we all love ourselves more than other people, but care more about their opinion than our own. – Marcus Aurelius", "If a man knows not which port he sails, no wind is favorable. - Seneca", "We are more often frightened than hurt; and we suffer more in imagination than in reality. – Seneca", "I begin to speak only when I’m certain what I’ll say isn’t better left unsaid. – Cato", "How long are you going to wait before you demand the best for yourself? – Epictetus", "That man lives badly who does not know how to die well. - Seneca", "I cannot escape death, but at least I can escape the fear of it. — Epictetus", "It is not death that a man should fear, but rather he should fear never beginning to live. — Marcus Aurelius", "I am not afraid of death, I just don’t want to be there when it happens. – Woody Allen", "Do not fear death so much but rather the inadequate life. – Bertolt Brecht", "To be evenminded is the greatest virtue. - Heraclitus", "Just keep in mind: the more we value things outside our control, the less control we have. - Epictetus", "The tranquility that comes when you stop caring what they say. Or think, or do. Only what you do. - Marcus Aurelius", "The whole future lies in uncertainty: live immediately. - Seneca", "It does not matter what you bear, but how you bear it. - Seneca", "To be calm is the highest achievement of the self. - Zen proverb", "He has the most who is content with the least. - Diogenes", "Self-control is strength. Right thought is mastery. Calmness is power. - James Allen", "Man conquers the world by conquering himself. - Zeno of Citium", "Be stoic: Just do the right thing. Just keep going. - Maxime Lagacé", "Success is based off of your willingness to work your ass off no matter what obstacles are in your way. - David Goggins", "When someone is properly grounded in life, they shouldn’t have to look outside themselves for approval. - Epictetus", "You have power over your mind — not outside events. Realize this, and you will find strength. - Marcus Aurelius", "Remembering that you are going to die is the best way I know to avoid the trap of thinking you have something to lose. - Steve Jobs"]
    
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
            // scheduling 30 years of notifications
                    
                    var rangeOfNotifications = 1...100
                    var calendarValue = 1
                    var addingStep: Calendar.Component = .day
                    
                    switch schedule {
                    case .daily:
                        addingStep = .day
                        calendarValue = 1
                        rangeOfNotifications = 0...12000
                    case .twice:
                        addingStep = .day
                        calendarValue = 1
                        rangeOfNotifications = 0...12000
                    case .weekly:
                        addingStep = .day
                        calendarValue = 7
                        rangeOfNotifications = 0...1560
                    case .monthly:
                        addingStep = .month
                        calendarValue = 1
                        rangeOfNotifications = 0...360
                    
                    }
                    
                            for notificationNumber in rangeOfNotifications {
                                
                                func addingNotificationRequest(_ addingStep: Calendar.Component, _ calendarValue: Int, _ notificationNumber: ClosedRange<Int>.Element, _ start: Int, _ end: Int, _ center: UNUserNotificationCenter, mementoText: String) {
                                    let randomIndex = Int.random(in: 0..<randomQuotes.count)
                                    let quote = randomQuotes[randomIndex]
                                    
                                    let content = UNMutableNotificationContent()
                                    content.title = mementoText
                                    content.body = quote
                                    content.sound = UNNotificationSound.default
                                    content.categoryIdentifier = "reminder"
                                    
                                    var dateComponents = DateComponents()
                                    let startDate = Date.now
                                    let endDate = Calendar.current.date(byAdding: addingStep, value: calendarValue * notificationNumber, to: startDate)!
                                    
                                    if schedule == .monthly {
                                        dateComponents.month = Calendar.current.dateComponents([.month], from: endDate).month
                                    }
                                    
                                    dateComponents.day = Calendar.current.dateComponents([.day], from: endDate).day
                                    dateComponents.hour = .random(in: start..<end)
                                    dateComponents.minute = .random(in: 0...59)
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                    
                                    
                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                    
                                    center.add(request)
                                    
                                    if notificationNumber < 40 {
                                        print(dateComponents)
                                    }
                                }
                                
                                addingNotificationRequest(addingStep, calendarValue, notificationNumber, start, end, center, mementoText: mementoText)
                                
                                if schedule == .twice {
                                    
                                    addingNotificationRequest(addingStep, calendarValue, notificationNumber, start, end, center, mementoText: mementoText)

                            }
                        }
        }
        
    }
}
