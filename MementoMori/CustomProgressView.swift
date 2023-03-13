//
//  ProgressView.swift
//  MementoMori
//
//  Created by Simon Lang on 26.02.23.
//

import SwiftUI

struct CustomProgressView: View {
    var progress: Double
    var accentColor: Color
    var largeDesign: Bool
    
    var animationDuration = 1.6
    
    @State var changingNumber = 0.00
    
    
    var progressRounded: Double {
        return (progress * 10000).rounded() / 100
    }
    var percentage: String {
        return String(format: "%.2f", progressRounded)
    }
    
    
    var timeCalculation: Double {
        let times = animationDuration / 0.0004
        let chunk = progressRounded / times
        return chunk
    }
    
    @State private var animating = false
    
    let timer = Timer.publish(every: 0.0004, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .opacity(0.2)

            Circle()
                .trim(from: 0.0, to: animating ? progress : 0)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(accentColor)
                .rotationEffect(Angle(degrees: 270))
            
            VStack {
                Text(String(format: "%.2f", changingNumber) + "%")
                    .font(largeDesign ? .largeTitle : .title2)
                    .fontWeight(.bold)
                    .monospacedDigit()
                Text("complete")
                    .font(largeDesign ? .title2 : .title3)
            }
        }
            .frame(height: 200)
            .padding()
            .onAppear {
                withAnimation(.easeOut(duration: animationDuration)) {
                    animating = true
                }
            }
            .onReceive(timer) { input in
                if changingNumber < progressRounded - 0.2 {
                    changingNumber += timeCalculation
                } else if changingNumber < progressRounded {
                    changingNumber += 0.01
                } else {
                    timer.upstream.connect().cancel()
                
                }
            }     
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(progress: 0.74525, accentColor: .red, largeDesign: false)
    }
}
