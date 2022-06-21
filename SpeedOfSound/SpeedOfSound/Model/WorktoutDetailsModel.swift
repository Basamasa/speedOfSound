//
//  WorktoutDetailsModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 05.05.22.
//

import HealthKit
import Foundation
import CoreMotion

class WorktoutDetailsModel {
    let workout: HKWorkout
    let store = HKHealthStore()
    var runningWorkoutsHeartRate: [Double] = []
    
    init (workout: HKWorkout) {
        self.workout = workout
    }
    
    var indoorWorktoutMeta: String {
        let type = workout.metadata?[HKMetadataKeyIndoorWorkout]
        guard type != nil else {return ""}
        return type as! Int == 1 ? "Indoor " : "Outdoor "
    }
    
    var feedbackStyle: String {
        return nameMeta.feedback == 0 ? "Notification" : "Sound"
    }
    
    var lowBPM: Int {
        return nameMeta.lowBPM
    }
    
    var highBPM: Int {
        return nameMeta.highBPM
    }
    
    var cadence: Int {
        return nameMeta.cadence
    }
    
    var numberOfTimeGotLooked: Int {
        return nameMeta.numberOfGotLooked
    }
    
    private var nameMeta: WorkoutModel {
        let workoutData = workout.metadata?[HKMetadataKeyWorkoutBrandName]
        guard workoutData != nil else {return WorkoutModel.defaultValue}
        
        return WorkoutModel.parserData(data: workoutData as! String)
    }
    
    var activityName: String {
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
    
    var durationSeconds: Int {
        return Int(floor(workout.duration ))
    }
    
    func getDuration() -> (Int, Int, Int) {

        let time = NSInteger(workout.duration)

        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return (hours, minutes, seconds)
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
        dateFormatter.dateFormat = "MMM d"
        let dateString = dateFormatter.string(from: workout.startDate)
        return dateString
    }
    
    var endDate: Date {
        return workout.endDate
    }
    
    var type: HKWorkoutActivityType {
        return workout.workoutActivityType
    }
    
    var startTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: startDate)
    }
    
    var endTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: endDate)
    }
    
    func getSteps(completion: @escaping ((Double) -> Void)) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0

            guard let result = result else {
                print("\(String(describing: error?.localizedDescription)) ")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }

            completion(resultCount)
        }
        
        store.execute(query)
    }
    
    func getHeartRates(completion: @escaping (([Double]) -> Void)) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
                
        let predicate = HKQuery.predicateForSamples(withStart:startDate, end: endDate, options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
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
