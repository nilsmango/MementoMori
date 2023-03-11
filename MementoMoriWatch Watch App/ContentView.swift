//
//  ContentView.swift
//  MementoMoriWatch Watch App
//
//  Created by Simon Lang on 11.03.23.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        VStack {
            Spacer()
            CustomProgressView(progress: Double(lifeTime.ageInDays) / Double(lifeTime.lifeExpectancyInDays), accentColor: lifeTime.accentColor)
            
            
            Text("Days left to live if you are so lucky:")
                .font(.title2)
                .padding(.top)
            DateTimerView(futureDate: lifeTime.dateOfEndOfLife)
                .font(.title)
                .fontWeight(.bold)
            
            if lifeTime.lastCheckActive {

                Text(dateToDateFormatted(from: lastCheck, to: now).hasDays ? "Days lost since your last check-in:" : "Time lost since your last check-in:")
                    .font(.title2)
                    .padding(.top)
            Text(dateToDateFormatted(from: lastCheck, to: now).string)
                    .font(.title)
                    .fontWeight(.bold)
                
            }
            
            Spacer()
            
            if lifeTime.bottomIcon != .none {
                ZStack {
                    Image(lifeTime.iconString)
                        .resizable()
                        .scaledToFit()

                if lifeTime.bottomIcon == .animatedHourglass {
                    SpriteView(scene: Sandfall(), options: [.allowsTransparency])
                    SpriteView(scene: SandScatter(), options: [.allowsTransparency])
                }
                }
                .shadow(radius: 2, x: 3, y: 1)
                .frame(height: 60)
                .offset(skullOffset)
                .gesture(
                    DragGesture().onChanged { value in
                        skullOffset = value.translation
                    }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.2)) {
                                skullOffset = .zero
                            }
                        }
                )
            }
            
            Spacer()

            if lifeTime.active {
                Label("Mementos active", systemImage: "checkmark")
                    .font(.title2)
                    .onTapGesture {
                        presentOptions.toggle()
                    }
            } else {
                Label("No Mementos active", systemImage: "xmark")
                    .font(.title2)
                    .onTapGesture {
                        presentOptions.toggle()
                    }
            }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
