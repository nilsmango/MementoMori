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
    
    @AppStorage("lastCheckIn") var lastCheck = Date.now
    
    // because .inactive was also firing when becoming active I had to use this hack.
    @AppStorage("myHack") var canUpdateLastCheck = false
    
    @State var now = Date.now
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView(lifeData: lifeData, lastCheck: lastCheck, now: now)
                .accentColor(lifeData.lifeTime.accentColor)
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        if canUpdateLastCheck == true {
                            lastCheck = Date.now
                            canUpdateLastCheck = false
                        }
                        
                    } else if phase == .active {
                        lifeData.load()
                        now = Date.now
                        canUpdateLastCheck = true
                    }
                }
        }
    }
}
