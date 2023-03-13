//
//  WatchLifeData.swift
//  MementoMoriWatch Watch App
//
//  Created by Simon Lang on 12.03.23.
//

import Foundation
import WatchConnectivity

class PhoneConnection: NSObject, WCSessionDelegate, ObservableObject {
    
    @Published var lifeTime: LifeTime = LifeTime()
    let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Message from Watch: The session has completed activation.")
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo message: [String : Any]) {
        
        DispatchQueue.main.async {
            print("Mapping in progress")
            self.lifeTime = message.values.first as! LifeTime
            
            self.save()
            
        }
    }
    
    
    // Load and save the local watch QR codes, works because of the extension. I honestly don't understand how.
    
    let saveKey = "WatchLife"
    
    func load() {
        let defaults = UserDefaults.standard
        lifeTime = try! defaults.decode(LifeTime.self, forKey: saveKey) ?? LifeTime()
    }
    
    func save() {
        let defaults = UserDefaults.standard
        try? defaults.encode(lifeTime, forKey: saveKey)

    }
    
}
