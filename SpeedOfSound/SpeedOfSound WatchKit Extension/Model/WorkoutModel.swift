//
//  WorkoutData.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import Foundation

struct WorkoutModel {
    var feedback: Int = 0
    var lowBPM: Int = 120
    var highBPM: Int = 140
    var cadence: Int = 120
    
    var getData: String {
        return "\(feedback)" + "-\(lowBPM)" + "-\(highBPM)" + "-\(cadence)"
    }
}
