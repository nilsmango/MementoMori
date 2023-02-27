//
//  LifeDots.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import SwiftUI

struct LifeDots: View {
    var body: some View {
        YourLifeInYears()
//            .padding()
//            .ignoresSafeArea()
//            .background(Color(red: 0.1, green: 0.3, blue: 0.2, opacity: 0.4))
    }
}

struct YourLifeInYears: View {
    @State private var lifeExpectancy: Int = 90
    @State private var age: Int = 38
    @State private var timeScale: TimeScale = .months
    @State private var color: Color = .red
    
    var columns: [GridItem] {
        switch timeScale {
        case .years:
            return Array(repeating: GridItem(.fixed(37)), count: 7)
        case .months:
            return Array(repeating: GridItem(.fixed(6)), count: 24)
        case .weeks:
            return Array(repeating: GridItem(.fixed(4), spacing: 3), count: 52)
        default:
            return Array(repeating: GridItem(.fixed(4), spacing: 3), count: 52)
        }
    }
    
    var numberOfDots: Int {
        switch timeScale {
        case .years:
            return lifeExpectancy
        case .months:
            return lifeExpectancy * 12
        case .weeks:
            return Int(Double(lifeExpectancy) * 52.17857)
        case .days:
            return lifeExpectancy * 365
        }
    }
    
    var alreadyLived: Int {
        switch timeScale {
        case .years:
            return age
        case .months:
            return age * 12
        case .weeks:
            return Int(Double(age) * 52.17857)
        case .days:
            return Int(Double(age) * 52.17857 * 7)
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
            return 4
        }
    }
    
    

    var body: some View {
        VStack {
            Text("Your Life in " + timeScale.rawValue.capitalized)
                .font(.title)
            
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(1...numberOfDots, id: \.self) { circles in
                    if circles <= alreadyLived {
                        Circle().fill(color)
                            .frame(width: framing,height: framing)
                                                
                    } else {
                        Circle().fill(color)
                            .opacity(0.5)
                            .frame(width: framing,height: framing)
                    }
                }
            }
            .padding([.leading, .trailing])
            
            
            
            
            
        
        }
        
    }
}

struct LifeDots_Previews: PreviewProvider {
    static var previews: some View {
        LifeDots()
    }
}
