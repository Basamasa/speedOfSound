//
//  WorkoutData.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import Foundation

struct WorkoutModel {
    var feedback: Feedbackstyle = .notification
    var lowBPM: Int = 120
    var highBPM: Int = 140
    var cadence: Int = 120
    
    var getData: String {
        return "\(feedback.rawValue)" + "-\(lowBPM)" + "-\(highBPM)" + "-\(cadence)"
    }
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
