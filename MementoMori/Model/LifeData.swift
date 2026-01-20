//
//  LifeData.swift
//  MementoMori
//
//  Created by Simon Lang on 25.02.23.
//

import Foundation

class LifeData: ObservableObject {
    
    private static var documentsFolder: URL {
        let appIdentifier = "group.memento"
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appIdentifier)!
    }
    
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("life.data")
    }
    
    
    @Published var lifeTime: LifeTime = LifeTime()
 
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            guard let jsonLifeTime = try? JSONDecoder().decode(LifeTime.self, from: data) else {
                fatalError("Couldn't decode saved codes data")
            }
            DispatchQueue.main.async {
                print("Loading data")
                self?.lifeTime = jsonLifeTime
            }
            
            // UPDATING NOTIFICATIONS
            Task { @MainActor in
                do {
                    try await MementoNotifications().scheduleRollingMementos(active: self!.lifeTime.active,
                                                                             mementoText: self!.lifeTime.mementoText,
                                                                             quote: self!.lifeTime.addRandomQuote,
                                                                             start: self!.lifeTime.startMemento,
                                                                             end: self!.lifeTime.endMemento,
                                                                             schedule: self!.lifeTime.schedule
                    )
                                            
                } catch {
                    print("Something went wrong on appear")
                }
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let lifeTime = self?.lifeTime else { fatalError("Self out of scope!") }
            guard let data = try? JSONEncoder().encode(lifeTime) else { fatalError("Error encoding data") }
            
            do {
                print("Saving data")
                let outFile = Self.fileURL
                try data.write(to: outFile)
//                WidgetCenter.shared.reloadAllTimelines()
                
            } catch {
                fatalError("Couldn't write to file")
            }
        }
    }
    
    
}
