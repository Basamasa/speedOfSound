//
//  SesssionManager.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 25.04.22.
//

import Foundation
import HealthKit
import WatchConnectivity
import Combine

class SessionManager: ObservableObject {
    var wcSession: WCSession
    let delegate: WCSessionDelegate
    let subject1 = PassthroughSubject<Int, Never>()
    let subject2 = PassthroughSubject<String, Never>()
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject1, workoutSubject: subject2)
        self.wcSession = session
        self.wcSession.delegate = self.delegate
        self.wcSession.activate()
    }
    
    private func sendMessage(_ message: String, count: Int? = nil, session: Int? = nil) {
        wcSession.sendMessage([message: count ?? session!], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func bpmchanged(_ count: Int) {
        sendMessage("count", count: count)
    }
    
    func workSessionBegin(isSoundFeedback: Bool) {
        if isSoundFeedback {
            while (!wcSession.isReachable) {
            }
            sendMessage("workSessionBegin", session: 1)
        }
    }
    
    func workSessionEnd() {
        sendMessage("workSessionBegin", session: 0)

    }
}
