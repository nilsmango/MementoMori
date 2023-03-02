//
//  DateTimerView.swift
//  MementoMori
//
//  Created by Simon Lang on 01.03.23.
//

import SwiftUI

struct DateTimerView: View {
    @State private var currentDate = Date.now
    let futureDate: Date
    
    
    private var days: String {
        let timeComponent = Calendar.current.dateComponents([.day, .hour, . minute, .second], from: currentDate, to: futureDate)
        
        let days = String(timeComponent.day!)
        let hours = String(format: "%02d", arguments: [timeComponent.hour!])
        let minutes = String(format: "%02d", arguments: [timeComponent.minute!])
        let seconds = String(format: "%02d", arguments: [timeComponent.second!])
        
        let formatted = days + " " + hours + ":" + minutes + ":" + seconds
        
        return formatted
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(days)
            .monospacedDigit()
            .onReceive(timer) { input in
                currentDate = input
                
            }
        
    }
}

struct DateTimerView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimerView(futureDate: Date(timeIntervalSinceReferenceDate: 40079648749.0))
    }
}
