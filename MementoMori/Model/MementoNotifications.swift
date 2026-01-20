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
    
    func scheduleRollingMementos(
        active: Bool,
        mementoText: String,
        quote: Bool,
        start: Int,
        end: Int,
        schedule: MementoSchedule
    ) async throws {
        print("starting to schedule reminders")
        let granted = try await center.requestAuthorization(options: [.alert, .sound])
        guard granted else { throw NotificationError.permissionDenied }
        
        // Always remove all "reminder" category notifications first
        let pending = await center.pendingNotificationRequests()
        let reminderIdentifiers = pending
            .filter { $0.content.categoryIdentifier == "reminder" }
            .map { $0.identifier }
        print("pending notifications found: \(pending.count)")
        center.removePendingNotificationRequests(withIdentifiers: reminderIdentifiers)
        print("removed pending notifications")
        guard active else {
            print("not active, returning")
            return }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let maxNotifications = 60
        let timesPerDay = schedule == .twice ? 2 : 1
        
        let quotes = loadQuotes().shuffled()
        var quoteIndex = 0
        var scheduledCount = 0
        var dayOffset = 0
        
        while scheduledCount < maxNotifications {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else {
                break
            }
            
            for _ in 0..<timesPerDay {
                print("adding reminder no: \(scheduledCount)")
                guard scheduledCount < maxNotifications else { break }
                
                var components = calendar.dateComponents([.year, .month, .day], from: date)
                components.hour = Int.random(in: start..<end)
                components.minute = Int.random(in: 0...59)
                
                let content = UNMutableNotificationContent()
                content.title = mementoText
                content.sound = .default
                content.categoryIdentifier = "reminder"
                
                let isLastNotification = scheduledCount == maxNotifications - 1
                if isLastNotification {
                    content.body = "Open the app to receive new mementos."
                } else if quote {
                    content.body = quotes[quoteIndex]
                    quoteIndex += 1
                } else {
                    content.body = ""
                }
                
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: components,
                    repeats: false
                )
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                try await center.add(request)
                scheduledCount += 1
            }
            
            dayOffset += 1
        }
        
        print("Rolling scheduler active — \(scheduledCount) notifications pending")
    }
    
//    func scheduleMemento(
//        active: Bool,
//        mementoText: String,
//        quote: Bool,
//        start: Int,
//        end: Int,
//        schedule: MementoSchedule,
//        progressCallback: @escaping (NotificationProgress) -> Void
//    ) async throws {
//        print("Starting scheduling")
//        
//        // Request permission first
//        let granted = try await center.requestAuthorization(options: [.alert, .sound])
//        
//        guard granted else {
//            throw NotificationError.permissionDenied
//        }
//        
//        print("Authorization granted")
//        
//        // Remove all pending notifications
//        center.removeAllPendingNotificationRequests()
//        
//        guard active else {
//            progressCallback(NotificationProgress(current: 0, total: 0, isComplete: true))
//            return
//        }
//        
//        // Generate random times for each day of the year
//        let daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
//        
//        var randomTimes: [[String: Int]] = daysInMonths.enumerated().flatMap { (monthIndex, daysInMonth) in
//            (1...daysInMonth).map { day in
//                [
//                    "month": monthIndex + 1,
//                    "day": day,
//                    "hour": Int.random(in: start..<end),
//                    "minute": Int.random(in: 0...59)
//                ]
//            }
//        }
//        
//        // Add second notifications if schedule is twice daily
//        if schedule == .twice {
//            let secondTimes = daysInMonths.enumerated().flatMap { (monthIndex, daysInMonth) in
//                (1...daysInMonth).map { day in
//                    [
//                        "month": monthIndex + 1,
//                        "day": day,
//                        "hour": Int.random(in: start..<end),
//                        "minute": Int.random(in: 0...59)
//                    ]
//                }
//            }
//            randomTimes += secondTimes
//        }
//        
//        let totalNotifications = randomTimes.count
//        progressCallback(NotificationProgress(current: 0, total: totalNotifications, isComplete: false))
//        
//        // Load and prepare quotes
//        let quotes = loadQuotes()
//        let numberToRemainInOrder = 26
//        let first26Quotes = Array(quotes.prefix(numberToRemainInOrder))
//        let restQuotes = Array(quotes.dropFirst(numberToRemainInOrder))
//        let randomQuotes = first26Quotes + restQuotes.shuffled()
//        let randomQuoteCount = randomQuotes.count
//        
//        var successfullyScheduled = 0
//        var errors: [Error] = []
//        
//        // Schedule notifications in batches to avoid overwhelming the system
//        let batchSize = 50
//        let batches = randomTimes.chunked(into: batchSize)
//        
//        for (batchIndex, batch) in batches.enumerated() {
//            var batchRequests: [UNNotificationRequest] = []
//            
//            for (indexInBatch, timeDict) in batch.enumerated() {
//                let globalIndex = batchIndex * batchSize + indexInBatch
//                
//                let quoteText: String
//                if quote {
//                    if globalIndex < randomQuoteCount {
//                        quoteText = randomQuotes[globalIndex]
//                    } else {
//                        quoteText = randomQuotes.randomElement() ?? "Remember this moment."
//                    }
//                } else {
//                    quoteText = ""
//                }
//                
//                let content = UNMutableNotificationContent()
//                content.title = mementoText
//                content.body = quoteText
//                content.sound = UNNotificationSound.default
//                content.categoryIdentifier = "reminder"
//                
//                var dateComponents = DateComponents()
//                dateComponents.month = timeDict["month"]
//                dateComponents.day = timeDict["day"]
//                dateComponents.hour = timeDict["hour"]
//                dateComponents.minute = timeDict["minute"]
//                
//                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//                
//                batchRequests.append(request)
//            }
//            
//            // Add batch of requests
//            for request in batchRequests {
//                do {
//                    try await center.add(request)
//                    successfullyScheduled += 1
//                    
//                    // Update progress
//                    progressCallback(NotificationProgress(
//                        current: successfullyScheduled,
//                        total: totalNotifications,
//                        isComplete: false
//                    ))
//                    
//                } catch {
//                    errors.append(error)
//                    print("Failed to schedule notification: \(error)")
//                }
//            }
//            
//            // Small delay between batches to prevent overwhelming the system
//            if batchIndex < batches.count - 1 {
//                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
//            }
//        }
//        
//        print("Successfully scheduled \(successfullyScheduled) out of \(totalNotifications) notifications")
//        
//        // Final progress update
//        progressCallback(NotificationProgress(
//            current: successfullyScheduled,
//            total: totalNotifications,
//            isComplete: true
//        ))
//        
//        if !errors.isEmpty {
//            throw NotificationError.partialFailure(successfullyScheduled, totalNotifications, errors)
//        }
//    }
}

struct NotificationProgress {
    let current: Int
    let total: Int
    let isComplete: Bool
}

// Helper extension to chunk arrays
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// Error types for better error handling
enum NotificationError: Error {
    case permissionDenied
    case partialFailure(Int, Int, [Error])
    
    var localizedDescription: String {
        switch self {
        case .permissionDenied:
            return "Notification permission denied"
        case .partialFailure(let successful, let total, _):
            return "Scheduled \(successful) out of \(total) notifications"
        }
    }
}

