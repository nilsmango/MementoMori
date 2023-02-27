//
//  ProgressView.swift
//  MementoMori
//
//  Created by Simon Lang on 26.02.23.
//

import SwiftUI

struct ProgressView: View {
    var progress: Double
    var accentColor: Color
    
    var percentage: String {
        let rounded = (progress * 10000).rounded() / 100
        let formatted = String(format: "%.2f", rounded)
        return formatted
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .opacity(0.2)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(accentColor)
                .rotationEffect(Angle(degrees: 270))
            
            VStack {
                Text(percentage + "%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("complete")
                    .font(.title2)
//                    .fontWeight(.bold)
            }
            
            
                
                
        }
            .frame(height: 200)
            .padding()

    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(progress: 0.74525, accentColor: .red)
    }
}
