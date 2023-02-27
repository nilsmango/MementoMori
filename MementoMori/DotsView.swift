//
//  DotsView.swift
//  MementoMori
//
//  Created by Simon Lang on 26.02.23.
//

import SwiftUI

struct DotsView: View {
    
    var timeScale: String
    var columns: [GridItem]
    var spacing: CGFloat
    var numberOfDots: Int
    var alreadyLived: Int
    var color: Color
    var framing: CGFloat
    
    var body: some View {
        VStack {
            
            Text(timeScale + " lived")
                .font(.title)
            
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(1...numberOfDots, id: \.self) { circles in
                    if circles <= alreadyLived {
                        Circle().fill(color)
                            .frame(width: framing, height: framing)

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

struct DotsView_Previews: PreviewProvider {
    static var previews: some View {
        DotsView(timeScale: "Years", columns: Array(repeating: GridItem(.fixed(37)), count: 7), spacing: 5, numberOfDots: 80, alreadyLived: 38, color: .red, framing: 5)
    }
}
