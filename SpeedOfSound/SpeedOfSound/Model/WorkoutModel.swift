//
//  WorkoutModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 16.05.22.
//

import Foundation

struct WorkoutModel: Equatable {
    var feedback: Int
    var lowBPM: Int
    var highBPM: Int
    var cadence: Int
    var numberOfGotLooked: Int
    var numberOfFeedback: Int
    var meanTimeNeededGetBackToZone: Int
    var age: Int
    var restingHeartRate: Int = 80
    
    static var defaultValue: WorkoutModel {
        WorkoutModel(feedback: 1, lowBPM: 120, highBPM: 140, cadence: 160, numberOfGotLooked: 0, numberOfFeedback: 0, meanTimeNeededGetBackToZone: 0, age: 20, restingHeartRate: 70)
    }
    
    static func parserData(data: String) -> WorkoutModel {
        guard data != "" else {
            return WorkoutModel.defaultValue
        }
        let arr = data.components(separatedBy: "-")
        if arr.count != 9 {
            return WorkoutModel.defaultValue
        }
        return WorkoutModel(feedback: Int(arr[0]) ?? defaultValue.feedback, lowBPM: Int(arr[1]) ?? defaultValue.lowBPM, highBPM: Int(arr[2]) ?? defaultValue.highBPM, cadence: Int(arr[3]) ?? defaultValue.cadence, numberOfGotLooked: Int(arr[4]) ?? defaultValue.numberOfGotLooked, numberOfFeedback: Int(arr[5]) ?? defaultValue.numberOfFeedback, meanTimeNeededGetBackToZone: Int(arr[6]) ?? defaultValue.meanTimeNeededGetBackToZone, age: Int(arr[7]) ?? defaultValue.age, restingHeartRate: Int(arr[8]) ?? defaultValue.restingHeartRate)
    }
}
