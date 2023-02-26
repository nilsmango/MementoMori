//
//  MementoMoriApp.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import SwiftUI

@main
struct MementoMoriApp: App {
    
    @StateObject private var lifeData = LifeData()
    
    var body: some Scene {
        WindowGroup {
            ContentView(lifeData: lifeData)
                .accentColor(lifeData.lifeTime.accentColor)
        }
    }
}
