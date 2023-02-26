//
//  ProgressBar.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import SwiftUI

struct ProgressBar: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 70)
                    .stroke(.black, lineWidth: 5)
                HStack {
                    RoundedRectangle(cornerRadius: 70)
                        .fill(.black)
                        .frame(width: 300)
                        .padding(5)
                    Spacer()
                }
                Text("70%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                    
                    
            }
                .frame(height: 100)
                .padding()

            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(.black)
                    .opacity(0.2)
                HStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(.blue)
                        .frame(width: 300)
                        
                    Spacer()
                }
                Text("70%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                    
                    
            }
                .frame(height: 50)
                .padding()
            
            ZStack {
                Circle()
                    .trim(from: 0.1, to: 0.9)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .opacity(0.2)
                    .rotationEffect(Angle(degrees: 90))
                
                Circle()
                    .trim(from: 0.1, to: 0.6)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.red)
                    .rotationEffect(Angle(degrees: 90))
                    
                
                Text("70%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                    
                    
            }
                .frame(height: 200)
                .padding()
            
            ZStack {
                Circle()

                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .opacity(0.2)

                
                Circle()
                    .trim(from: 0.0, to: 0.7)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.red)
                    .rotationEffect(Angle(degrees: 270))
                    
                
                Text("70%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                    
                    
            }
                .frame(height: 200)
                .padding()

        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
    }
}
