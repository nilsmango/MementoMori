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

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(dateToDateFormatted(from: currentDate, to: futureDate).string)
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
