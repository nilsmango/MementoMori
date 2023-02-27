//
//  TimeScale.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//


enum TimeScale: String, CaseIterable, Identifiable  {
    case years, months, weeks, days
    var id: Self { self }
}

enum PossibleColors: String, CaseIterable, Identifiable {
    case red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink, gray
    var id: Self { self }
}

enum PossibleGraphics: String, CaseIterable, Identifiable {
    case dots, progress
    var id: Self { self }
}

enum MementoSchedule: String, CaseIterable, Identifiable {
    case twice, daily, weekly, monthly, never
    var id: Self { self }
    
}
