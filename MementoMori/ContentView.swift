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
    
    @AppStorage("imageCarousel") var carousel = 3
    
    private var imageString: String {
        if carousel == 1 {
            return "skull0.3"
        } else if carousel == 2 {
            return "hourglass0.1"
        } else if carousel == 3 {
            return "hourglass0.2"
        } else {
            return "nada"
        }
    }
    
    
    @State private var presentOptions = false
    
    @State private var skullOffset = CGSize(width: 0.0, height: 0.0)
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    ProgressView(progress: Double(lifeData.lifeTime.ageInDays) / Double(lifeData.lifeTime.lifeExpectancyInDays), accentColor: lifeData.lifeTime.accentColor)
                
                
                Text("Days left to live if you are so lucky:")
                    .font(.title2)
                    .padding(.top)
                DateTimerView(futureDate: lifeData.lifeTime.dateOfEndOfLife)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                ZStack {
                    if carousel == 0 {
                        Image(imageString)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .colorInvert()
                    } else {
                        Image(imageString)
                            .resizable()
                            .scaledToFit()
                            
                    }
                    
                    
                    if carousel == 3 {
                        SpriteView(scene: Sandfall(), options: [.allowsTransparency])
                    }
                    
                    
                }
                
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
                    .onTapGesture {
                        carousel = (carousel + 1) % 4
                    }
                
                Spacer()

                if lifeData.lifeTime.active {
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
            .navigationTitle("Your Life")
            
            .toolbar {
                Button(action: { presentOptions.toggle() }) { Label("Options", systemImage: "ellipsis.circle")}
            }
            
            .onAppear() {
                if firstTime {
                    presentOptions = true
                    firstTime = false
                }
            }
            
            .sheet(isPresented: $presentOptions) {
                NavigationView {
                    OptionsView(lifeTime: $lifeData.lifeTime)
                        .navigationTitle("Options")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { presentOptions = false }) { Label("Dismiss", systemImage: "xmark.circle")}
                                    
                                }
                            }
                        
                }
                .accentColor(lifeData.lifeTime.accentColor)
            }
            .accentColor(lifeData.lifeTime.accentColor)
            
        }
        
    }
}


class Sandfall: SKScene {
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        
        // anchor point
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        
        // background color
        backgroundColor = .clear
        
        // creating a node and adding it to scene
        let node = SKEmitterNode(fileNamed: "SandParticles.sks")!
        addChild(node)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(lifeData: LifeData())
                }
}
