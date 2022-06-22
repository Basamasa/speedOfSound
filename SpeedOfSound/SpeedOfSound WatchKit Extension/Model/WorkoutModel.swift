//
//  WorkoutData.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import Foundation

struct WorkoutModel {
    // Preset
    var feedback: Feedbackstyle = .notification
    var lowBPM: Int = 120
    var highBPM: Int = 140
    var cadence: Int = 120
    var age: Int = 20 {
        didSet {
            calculateHeartRateZone(zone: .light)
        }
    }
    var restingHeartRate: Int = 80 {
        didSet {
            calculateHeartRateZone(zone: .light)
        }
    }
    
    // Postset (After workout)
    var numberOfGotLooked: Int = 0
    var numberOfFeedback: Int = 0
    var meanTimeNeededGetBackToZone: Int = 0
    
    var getData: String {
        return "\(feedback.rawValue)" + "-\(lowBPM)" + "-\(highBPM)" + "-\(cadence)" + "-\(numberOfGotLooked)" + "-\(numberOfFeedback)" + "-\(meanTimeNeededGetBackToZone)" + "-\(age)" + "-\(restingHeartRate)"
    }
    
    mutating func calculateHeartRateZone(zone: Zone) {
        let MHR = 220 - age
        let lowBPM = Int((Double(MHR - restingHeartRate) * (zone.rawValue - 0.1)) + Double(restingHeartRate))
        let highBPM = Int((Double(MHR - restingHeartRate) * zone.rawValue) + Double(restingHeartRate))
        
        self.lowBPM = lowBPM
        self.highBPM = highBPM
    }
}

enum Zone: Double {
    case veryLight = 0.6
    case light = 0.7
    case moderate = 0.8
    case hard = 0.9
    case max = 1.0
}

enum Feedbackstyle: Int {
    case notification = 0
    case sound = 1
    case sound2 = 2
}

enum CadenceStyle: String {
    case average
    case highest
    case current
}
