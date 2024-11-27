//
//  TimeInputView.swift
//  WatchDatePicker Watch App
//
//  Created by Simon Lang on 15.03.23.
//

import SwiftUI

struct TimeInputView: View {
    @Binding var selection: Date
    let initialSelection: Date
    
    private let calendar = Calendar.current
    
    private var newSelection: Date {
      calendar.date(from: DateComponents(
        year: calendar.component(.year, from: selection),
        month: calendar.component(.month, from: selection),
        day: calendar.component(.day, from: selection),
        hour: hours,
        minute: minutes
      ))!
    }
    
    @State private var hours = 13
    @State private var minutes = 34
    
    public init(selection: Binding<Date>) {
      _selection = selection
      initialSelection = selection.wrappedValue
      
      _hours = State(initialValue: calendar.component(.hour, from: self.selection))
      _minutes = State(initialValue: calendar.component(.minute, from: self.selection))
    }
    
    var body: some View {
        HStack {
            Picker("Hour", selection: $hours, content: {
                ForEach(0..<24) { hour in
                    Text(String(format: "%02d", hour))
                        .minimumScaleFactor(0.5)
                        .tag(hour)
                }
            })
            Text(":")
            
            Picker("Minute", selection: $minutes, content: {
                ForEach(0..<60, id: \.self) { minute in
                    Text(String(format: "%02d", minute))
                        .minimumScaleFactor(0.5)
                        .tag(minute)
                }
            })
        }
        .onChange(of: newSelection) { selection = $0 }
    }
}



struct TimeInputView_Previews: PreviewProvider {
    static var previews: some View {
        TimeInputView(selection: .constant(Date(timeIntervalSince1970: 31404030)))
    }
}
