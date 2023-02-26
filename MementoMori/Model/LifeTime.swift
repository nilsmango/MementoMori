//
//  LifeTime.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import Foundation
import SwiftUI


struct LifeTime {
    
    
    var birthDay: Date = Date(timeIntervalSinceReferenceDate: -123473789.0)
    
    var timeScale: TimeScale = .years
    
    var lifeExpectancyInYears: Int = 80
    
    /// Accent color chosen by the user.
    var accentColorSelection: PossibleColors = .red
    
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
    
    var ageInDays: Int {
        return Calendar.current.dateComponents([.day], from: birthDay).day ?? 0
    }
    var ageInWeeks: Int {
        return Int(ageInDays / 7)
    }
    
    var ageInMonths: Int {
        return Calendar.current.dateComponents([.month], from: birthDay).month ?? 0
    }
    
    var ageInYears: Int {
        return Calendar.current.dateComponents([.year], from: birthDay).month ?? 0
    }
    
    var dateOfEndOfLife: Date {
        var yearComponent = DateComponents()
        yearComponent.year = lifeExpectancyInYears - ageInYears
        let date = Calendar.current.date(from: yearComponent) ?? Date.now
        return date
    }
    
    var daysUntilDeath: Int {
        return Calendar.current.dateComponents([.day], from: Date.now, to: dateOfEndOfLife).day ?? 0
    }
    
    var weeksUntilDeath: Int {
        return daysUntilDeath * 7
    }
    
    var monthsUntilDeath: Int {
        return Calendar.current.dateComponents([.month], from: Date.now, to: dateOfEndOfLife).day ?? 0
    }
    
    var yearsUntilDeath: Int {
        return lifeExpectancyInYears - ageInYears
    }
    
    var lifeExpectancyInWeeks: Int {
        return Calendar.current.dateComponents([.day], from: birthDay, to: dateOfEndOfLife).day ?? 0 / 7
    }
    
    
    var columns: [GridItem] {
        switch timeScale {
        case .years:
            return Array(repeating: GridItem(.fixed(37)), count: 7)
        case .months:
            return Array(repeating: GridItem(.fixed(6)), count: 24)
        case .weeks:
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
        }
    }
    
    var timeScaleString: String {
        switch timeScale {
        case .years:
            return "Years"
        case .months:
            return "Months"
        case .weeks:
            return "Weeks"
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
        }
    }
    
    
    
}
