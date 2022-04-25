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
    
    func bpmchanged(_ count: Int) {
        wcSession.sendMessage(["count": count], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
}
