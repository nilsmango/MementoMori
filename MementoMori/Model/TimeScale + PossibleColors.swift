//
//  TimeScale.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//


enum TimeScale {
    case years
    case months
    case weeks
}

enum PossibleColors: String, CaseIterable, Identifiable {
    case red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink, gray
    var id: Self { self }
    
}
