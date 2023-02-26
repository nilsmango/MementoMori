//
//  ContentView.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var lifeData: LifeData
    
    @State private var presentOptions = false
        
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text(String(lifeData.lifeTime.numberOfDots))
            }
            .padding()
            .navigationTitle("Your Life")
            
            .toolbar {
                Button(action: { presentOptions = true }) { Label("Options", systemImage: "ellipsis.circle")}
            }
            .sheet(isPresented: $presentOptions) {
                NavigationView {
                    OptionsView(lifeTime: $lifeData.lifeTime)
                        .navigationTitle("Options")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { presentOptions = false }) { Label("Dismiss", systemImage: "x.circle.fill")}
                                }
                            }
                        
                }
                .accentColor(lifeData.lifeTime.accentColor)
            }
            .accentColor(lifeData.lifeTime.accentColor)
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(lifeData: LifeData())
                }
}
