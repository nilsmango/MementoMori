//
//  TimeScale.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import Foundation

enum TimeScale: String, CaseIterable, Identifiable, Codable {
    case years, months, weeks, days
    var id: Self { self }
}

enum PossibleColors: String, CaseIterable, Identifiable, Codable {
    case red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink, gray
    var id: Self { self }
}

enum PossibleGraphics: String, CaseIterable, Identifiable, Codable {
    case dots, progress
    var id: Self { self }
}

enum MementoSchedule: String, CaseIterable, Identifiable, Codable {
    case twice, daily, weekly, monthly
    var id: Self { self }
    
}

struct MementoStatus: Equatable, Codable {
    var active: Bool
    var schedule: MementoSchedule
    var startMemento: Int
    var endMemento: Int
    var mementoText: String
    var addRandomQuote: Bool
}

enum BottomIcon: String, CaseIterable, Identifiable, Codable {
    case skull, hourglass, animatedHourglass, none
    var id: Self { self }
}



/// Time between dates formatted into a string of days

func dateToDateFormatted(from: Date, to: Date) -> (string: String, hasDays: Bool) {
    let timeComponent = Calendar.current.dateComponents([.day, .hour, . minute, .second], from: from, to: to)
    
    let days = String(timeComponent.day!)
    let hours = String(format: "%02d", arguments: [timeComponent.hour!])
    let minutes = String(format: "%02d", arguments: [timeComponent.minute!])
    let seconds = String(format: "%02d", arguments: [timeComponent.second!])
    
    if days == "0" {
        let time = hours + ":" + minutes + ":" + seconds
        return (time, false)
    } else {
        let formatted = days + " " + hours + ":" + minutes + ":" + seconds
        return (formatted, true)
    }
    
}


extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
