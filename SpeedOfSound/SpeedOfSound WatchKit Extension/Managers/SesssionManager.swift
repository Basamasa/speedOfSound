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
    let subject = PassthroughSubject<Int, Never>()
    @Published private(set) var count: Int = 0
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject)
        self.wcSession = session
        self.wcSession.delegate = self.delegate
        self.wcSession.activate()
           
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
    }
    
    private func sendMessage(_ message: String, count: Int? = nil, session: Int? = nil) {
        wcSession.sendMessage([message: count ?? session!], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func bpmchanged(_ count: Int) {
        sendMessage("count", count: count)
    }
    
    func workSessionBegin() {
        while (!wcSession.isReachable) {
            print("haha")
        }
        sendMessage("workSessionBegin", session: 1)

    }
    
    func workSessionEnd() {
        sendMessage("workSessionBegin", session: 0)

    }
}
