//
//  ViewModelPhone.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 24.04.22.
//

import Foundation
import Combine
import WatchConnectivity

class ViewModelPhone: ObservableObject {
    
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<Int, Never>()
       
    @Published private(set) var count: Int = 0
       
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
           
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
    }
}

