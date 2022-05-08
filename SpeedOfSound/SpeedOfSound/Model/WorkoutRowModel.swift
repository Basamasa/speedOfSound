//
//  WorkoutRowModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 03.05.22.
//

import HealthKit

struct WorkoutRowModel {
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
    
    var distance: String {
        return workout.totalDistance != nil ? String(format:"%0.2f", workout.totalDistance!.doubleValue(for: HKUnit.meter())/1000) : "-"
    }
    
    var durationHours: Int {
        return Int(floor(workout.duration / 3600))
    }
    
    var durationMinutes: Int {
        return Int(floor(workout.duration.truncatingRemainder(dividingBy: 3600)) / 60)
    }
    
    var energyBurned: String {
        return workout.totalEnergyBurned != nil ? String(format:"%0.f", workout.totalEnergyBurned!.doubleValue(for: HKUnit.kilocalorie())) : "-"
    }
    
    var imageName: String {
        return workout.workoutActivityType.associatedImageName
    }
}
