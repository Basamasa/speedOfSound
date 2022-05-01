//
//  ViewModelPhone.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 24.04.22.
//

import Foundation
import Combine
import WatchConnectivity

class HeartRateViewModel: ObservableObject {
    
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject1 = PassthroughSubject<Int, Never>()
    let subject2 = PassthroughSubject<Bool, Never>()
       
    @Published private(set) var count: Int = 0
    
    @Published private(set) var sessionWorkout: Bool = false
       
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject1, sessionWorkoutSubject: subject2)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
           
        subject1
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
        
        subject2
            .receive(on: DispatchQueue.main)
            .assign(to: &$sessionWorkout)
    }
}

