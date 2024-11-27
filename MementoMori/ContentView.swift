//
//  ContentView.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @ObservedObject var lifeData: LifeData
    
    @AppStorage("firstTimeActive") var firstTime = true
    
    var lastCheck: Date
    var now: Date
    
    // "Alias" so you don't have to write lifeData.lifeTime each time
    private var lifeTime: LifeTime {
        return lifeData.lifeTime
    }
    
  
    @State private var presentOptions = false
    
    @State private var skullOffset = CGSize(width: 0.0, height: 0.0)
    @State private var progressOffset = CGSize(width: 0.0, height: 0.0)
        
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                CustomProgressView(progress: Double(lifeTime.ageInDays) / Double(lifeTime.lifeExpectancyInDays), accentColor: lifeTime.accentColor, largeDesign: true)
                    .offset(progressOffset)
                    .gesture(
                        DragGesture().onChanged { value in
                            progressOffset = CGSize(width: value.translation.width, height: value.translation.height)
                        }
                            .onEnded { value in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.2)) {
                                    progressOffset = .zero
                                }
                            }
                    )
                
                
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
//                    .shadow(radius: 3, x: 1, y: 0.5)
                    .frame(height: 60)
                    .offset(skullOffset)
                    .gesture(
                        DragGesture().onChanged { value in
                            skullOffset = CGSize(width: value.translation.width, height: value.translation.height)
                        }
                            .onEnded { value in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.2)) {
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
                
            }
            
            .padding()
            .navigationTitle("Memento Mori")
            
            .toolbar {
                Button(action: { presentOptions.toggle() }) {
                    Label("Options", systemImage: "ellipsis.circle")
                        
                }
                .tint(lifeTime.accentColor)
            }
            
            .onAppear() {
              
                if firstTime {
                    presentOptions = true
                    firstTime = false
                }
                
            }
            
            
            .sheet(isPresented: $presentOptions, onDismiss: {
                lifeData.save()
                }) {
                NavigationView {
                    OptionsView(lifeTime: $lifeData.lifeTime)
                        .navigationTitle("Options")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { presentOptions = false }) { Label("Dismiss", systemImage: "xmark.circle")}
                                    
                                }
                            }
                        
                }
                .accentColor(lifeTime.accentColor)
            }
            .accentColor(lifeTime.accentColor)
            
        }
        
    }
}


//class Sandfall: SKScene {
//    override func sceneDidLoad() {
//        
//        size = UIScreen.main.bounds.size
//        scaleMode = .resizeFill
//        
//        
//        // anchor point
//        anchorPoint = CGPoint(x: 0.5, y: 0.55)
//        
//        // background color
//        backgroundColor = .clear
//        
//        // creating a node and adding it to scene
//        let node = SKEmitterNode(fileNamed: "SandParticles.sks")!
//        addChild(node)
//        
//    }
//}
//
//class SandScatter: SKScene {
//    override func sceneDidLoad() {
//        
//        size = UIScreen.main.bounds.size
//        scaleMode = .resizeFill
//        
//        
//        // anchor point
//        anchorPoint = CGPoint(x: 0.5, y: 0.3)
//        
//        // background color
//        backgroundColor = .clear
//        
//        // creating a node and adding it to scene
//        let node = SKEmitterNode(fileNamed: "SandParticlesScatter.sks")!
//        addChild(node)
//        
//    }
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(lifeData: LifeData(), lastCheck: Date.init(timeIntervalSinceNow: -43322), now: Date.now)
                }
}
