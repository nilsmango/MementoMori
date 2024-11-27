//
//  DateInputView.swift
//  WatchDatePicker Watch App
//
//  Created by Simon Lang on 15.03.23.
//

import SwiftUI

struct DateInputView: View {
    @Binding var selection: Date
    @Binding var presented: Bool
    
    @State private var year = 1919
    @State private var month = 9
    @State private var day = 1
    
    
    
    private func submitDate() {
        presented = false
        selection = newSelection
    }
    
    
    init(selection: Binding<Date>, presented: Binding<Bool>) {
        _selection = selection
        _presented = presented

        _year = State(initialValue: calendar.component(.year, from: self.selection))
        _month = State(initialValue: calendar.component(.month, from: self.selection))
        _day = State(initialValue: calendar.component(.day, from: self.selection))
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private let calendar = Calendar.current
    
    private var newSelection: Date {
      calendar.date(from: DateComponents(
        year: year,
        month: month,
        day: day,
        hour: calendar.component(.hour, from: selection),
        minute: calendar.component(.minute, from: selection)
      ))!
    }
    
    
    
    private var yearRange: Range<Int> {
      let lowerBound = 1919
      let upperBound = calendar.component(.year, from: .now)
   
      return lowerBound..<(upperBound + 1)
    }
    
    private var monthRange: [EnumeratedSequence<[String]>.Element] {
      let symbols = Array(calendar.shortMonthSymbols.enumerated())
      let lowerBound = 0
      let upperBound = symbols.count
      
      return Array(symbols[lowerBound..<upperBound])
    }
    
    private var dayRange: Range<Int> {
        let days = calendar.range(of: .day, in: .month, for: newSelection)!
        
        return days
    }
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Picker("Day", selection: $day, content: {
                        ForEach(dayRange, id: \.self) { day in
                            Text(String(day))
                                .minimumScaleFactor(0.5)
                                .tag(day)
                        }
                    })
                    
                    Picker("Month", selection: $month, content: {
                        ForEach(monthRange, id: \.offset) { offset, month in
                            Text(month)
                                .minimumScaleFactor(0.5)
                                .tag(offset + 1)
                        }
                    })
                    Picker("Year", selection: $year, content: {
                        ForEach(yearRange, id: \.self) { year in
                            Text(String(year))
                                .minimumScaleFactor(0.5)
                                .tag(year)
                        }
                    })
                }
                
                NavigationLink("Continue") {
                    TimeInputView(selection: $selection)
                        .navigationTitle(dateFormatter.string(from: selection))
                        .navigationBarTitleDisplayMode(.inline)
                        .padding(.bottom)
                        .toolbar {
                          ToolbarItem(placement: .confirmationAction) {
                              Button(action: {
                                  submitDate()
                              }
                                  ) {
                              Text("Done")
                                      .foregroundColor(.green)
                            }
                                  
                          }
                        }
                    }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.background)
                .tint(.green)
                .padding()
            }
            .edgesIgnoringSafeArea(.bottom)
            .onChange(of: newSelection) { selection = $0 }
        }
        
    }
}

struct DateInputView_Previews: PreviewProvider {
    static var previews: some View {
        DateInputView(selection: .constant(Date(timeIntervalSince1970: 31404030)), presented: .constant(true))
    }
}
