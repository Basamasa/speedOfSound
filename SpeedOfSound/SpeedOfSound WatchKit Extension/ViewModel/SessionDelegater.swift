//
//  SessionDelegater.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 24.04.22.
//

import Foundation
import WatchConnectivity
import Combine

final class SessionDelegater: NSObject, WCSessionDelegate {
    let countSubject: PassthroughSubject<Int, Never>
    let workoutSubject: PassthroughSubject<String, Never>
    let cadenceSubject: PassthroughSubject<Int, Never>
    
    init(countSubject: PassthroughSubject<Int, Never>, workoutSubject: PassthroughSubject<String, Never>, cadenceSubject: PassthroughSubject<Int, Never>) {
        self.countSubject = countSubject
        self.workoutSubject = workoutSubject
        self.cadenceSubject = cadenceSubject
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Protocol comformance only
        // Not needed for this demo
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let count = message["workoutMessage"] as? String {
                self.workoutSubject.send(count)
            } else {
                print("There was an error")
            }
            
        }
    }
}
