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
    
    static var defaultValue: WorkoutModel {
        WorkoutModel(feedback: 1, lowBPM: 120, highBPM: 140, cadence: 160, numberOfGotLooked: 0)
    }
    
    static func parserData(data: String) -> WorkoutModel {
        guard data != "" else {
            return WorkoutModel.defaultValue
        }
        let arr = data.components(separatedBy: "-")
        if arr.count != 5 {
            return WorkoutModel.defaultValue
        }
        return WorkoutModel(feedback: Int(arr[0]) ?? defaultValue.feedback, lowBPM: Int(arr[1]) ?? defaultValue.lowBPM, highBPM: Int(arr[2]) ?? defaultValue.highBPM, cadence: Int(arr[3]) ?? defaultValue.cadence, numberOfGotLooked: Int(arr[4]) ?? defaultValue.numberOfGotLooked)
    }
}
