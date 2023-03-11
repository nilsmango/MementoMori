//
//  LifeTime.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import Foundation
import SwiftUI


struct LifeTime: Codable {
    
    
    var birthDay: Date = Date(timeIntervalSinceReferenceDate: -479673789.0)
    
    var timeScale: TimeScale = .days
    
    var graphic: PossibleGraphics = .progress
    
    var lifeExpectancyInYears: Int = 75
    
    /// Accent color chosen by the user.
    var accentColorSelection: PossibleColors = .indigo
    
    /// Chosen bottom icon
    var bottomIcon: BottomIcon = .animatedHourglass
    
    /// Image string for chosen bottom icon
    var iconString: String {
        switch bottomIcon {
        case .animatedHourglass:
            return "hourglass0.2"
        case .skull:
            return "skull0.3"
        case .hourglass:
            return "hourglass0.1"
        case .none:
            return "nada"
        }
    }

    
    /// Accent color output
    var accentColor: Color {
        switch accentColorSelection {
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .mint:
            return Color.mint
        case .teal:
            return Color.teal
        case .cyan:
            return Color.cyan
        case .blue:
            return Color.blue
        case .indigo:
            return Color.indigo
        case .purple:
            return Color.purple
        case .pink:
            return Color.pink
        case .gray:
            return Color.gray
        
        }
    }
    
    func getColor(selection: PossibleColors) -> Color {
        switch selection {
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .mint:
            return Color.mint
        case .teal:
            return Color.teal
        case .cyan:
            return Color.cyan
        case .blue:
            return Color.blue
        case .indigo:
            return Color.indigo
        case .purple:
            return Color.purple
        case .pink:
            return Color.pink
        case .gray:
            return Color.gray
      
        }
    }
    
    var lifeExpectancyInMonths: Int {
        return lifeExpectancyInYears * 12
    }
    
    var lifeExpectancyInWeeks: Int {
        return (Calendar.current.dateComponents([.day], from: birthDay, to: dateOfEndOfLife).day ?? 7) / 7
    }
    
    var lifeExpectancyInDays: Int {
        return Calendar.current.dateComponents([.day], from: birthDay, to: dateOfEndOfLife).day ?? 0
    }
    
    
    var ageInDays: Int {
        return Calendar.current.dateComponents([.day], from: birthDay, to: Date.now).day ?? 0
    }
    var ageInWeeks: Int {
        return Int(ageInDays / 7)
    }
    
    var ageInMonths: Int {
        return Calendar.current.dateComponents([.month], from: birthDay, to: Date.now).month ?? 0
    }
    
    var ageInYears: Int {
        return Calendar.current.dateComponents([.year], from: birthDay, to: Date.now).year ?? 0
    }
    
    var dateOfEndOfLife: Date {
        var yearComponent = DateComponents()
        yearComponent.year = (Calendar.current.dateComponents([.year], from: Date.now).year ?? 0) + lifeExpectancyInYears - ageInYears
        let date = Calendar.current.date(from: yearComponent) ?? Date.now
        return date
    }
    
    var daysUntilDeath: Int {
        return Calendar.current.dateComponents([.day], from: Date.now, to: dateOfEndOfLife).day ?? 0
    }
    
    var weeksUntilDeath: Int {
        return daysUntilDeath / 7
    }
    
    var monthsUntilDeath: Int {
        return Calendar.current.dateComponents([.month], from: Date.now, to: dateOfEndOfLife).month ?? 0
    }
    
    var yearsUntilDeath: Int {
        return lifeExpectancyInYears - ageInYears
    }
    
    
    
    
    var columns: [GridItem] {
        switch timeScale {
        case .years:
            return Array(repeating: GridItem(.fixed(37)), count: 7)
        case .months:
            return Array(repeating: GridItem(.fixed(6)), count: 24)
        case .weeks:
            return Array(repeating: GridItem(.fixed(4), spacing: 3), count: 52)
        case .days:
            return Array(repeating: GridItem(.fixed(4), spacing: 3), count: 52)
        }
    }
    
    var numberOfDots: Int {
        switch timeScale {
        case .years:
            return lifeExpectancyInYears
        case .months:
            return lifeExpectancyInYears * 12
        case .weeks:
            return lifeExpectancyInWeeks
        case .days:
            return lifeExpectancyInWeeks * 7
        }
    }
    
    var alreadyLived: Int {
        switch timeScale {
        case .years:
            return ageInYears
        case .months:
            return ageInMonths
        case .weeks:
            return ageInWeeks
        case .days:
            return ageInWeeks * 7
        }
    }
    
    var spacing: CGFloat {
        switch timeScale {
        case .years:
            return 10
        case .months:
            return 4
        case .weeks:
            return 3
        case .days:
            return 2
        }
    }
    
    var framing: CGFloat {
        switch timeScale {
        case .years:
            return 35
        case .months:
            return 11
        case .weeks:
            return 5
        case .days:
            return 3
        }
    }
    
    
    // Mementos
    
    var active: Bool = false
    
    var schedule: MementoSchedule = .daily
    
    var startMemento: Int = 8
    
    var endMemento: Int = 20

    var mementoText: String = "Memento Mori!"
    
    var addRandomQuote: Bool = false
    
    var mementoStatus: MementoStatus = MementoStatus(active: false,schedule: .daily, startMemento: 20, endMemento: 20, mementoText: "Memento Mori", addRandomQuote: true)
    
    
    // Activate last check in
   
    var lastCheckActive: Bool = false
}
