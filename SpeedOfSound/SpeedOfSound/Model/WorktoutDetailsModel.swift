//
//  WorktoutDetailsModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 05.05.22.
//

import HealthKit

class WorktoutDetailsModel {
    let workout: HKWorkout
    let store = HKHealthStore()
    var runningWorkoutsHeartRate: [Double] = []
    
    init (workout: HKWorkout) {
        self.workout = workout
    }
    var activityName: String {
//        workout.hk == 
        return workout.workoutActivityType.name
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
    
    var startDate: Date {
        return workout.startDate
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateString = dateFormatter.string(from: workout.startDate)
        return dateString
    }
    
    var endDate: Date {
        return workout.endDate
    }
    
    var type: HKWorkoutActivityType {
        return workout.workoutActivityType
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
    
    func getSteps(completion: @escaping (([Double]) -> Void)) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart:startDate, end: endDate, options: .strictEndDate)

    }
    
    func getHeartRates(completion: @escaping (([Double]) -> Void)) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
                
        let predicate = HKQuery.predicateForSamples(withStart:startDate, end: endDate, options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { sample, result, error in
            guard error == nil else {
                return
            }
            
            let unit = HKUnit(from: "count/min")
            var results: [Double] = []
            guard let realResult = result else {return}
            for singleResult in realResult {
                let data = singleResult as! HKQuantitySample
                let latestHr = data.quantity.doubleValue(for: unit)
                results.append(latestHr)
            }
            completion(results)
        }
        
        store.execute(query)
    }
}
