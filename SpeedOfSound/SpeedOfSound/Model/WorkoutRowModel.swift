//
//  WorkoutRowModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 03.05.22.
//

import HealthKit

struct WorkoutRowModel1 {
    let workout: HKWorkout
    
    var activityName: String {
        return workout.workoutActivityType.name
    }
    
    var startTime: (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateString = dateFormatter.string(from: workout.startDate)
        let prefix = dateString.prefix(dateString.count - 2)
        let suffix = dateString.suffix(2)

        return (String(prefix), String(suffix))
    }
    
    var endTime: (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateString = dateFormatter.string(from: workout.endDate)
        let prefix = dateString.prefix(dateString.count - 2)
        let suffix = dateString.suffix(2)

        return (String(prefix), String(suffix))
    }
    
    var durationHours: Int {
        return Int(floor(workout.duration / 3600))
    }
    
    var durationMinutes: Int {
        return Int(floor(workout.duration.truncatingRemainder(dividingBy: 3600)) / 60)
    }
    
    var imageName: String {
        return workout.workoutActivityType.associatedImageName
    }
}
