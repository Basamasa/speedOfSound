//
//  SessionDelegater.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 24.04.22.
//

import Combine
import WatchConnectivity

class SessionDelegater: NSObject, WCSessionDelegate {
    let countSubject: PassthroughSubject<Int, Never>
    let sessionWorkoutSubject: PassthroughSubject<Bool, Never>
    
    init(countSubject: PassthroughSubject<Int, Never>, sessionWorkoutSubject: PassthroughSubject<Bool, Never>) {
        self.countSubject = countSubject
        self.sessionWorkoutSubject = sessionWorkoutSubject
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Protocol comformance only
        // Not needed for this demo
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let count = message["count"] as? Int {
                self.countSubject.send(count)
            } else if let session = message["workSessionBegin"] as? Bool {
                self.sessionWorkoutSubject.send(session)
            } else {
                print("There was an error")
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }    
}
