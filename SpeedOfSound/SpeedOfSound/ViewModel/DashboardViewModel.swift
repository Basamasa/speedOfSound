//
//  DashboardViewModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 03.05.22.
//

import HealthKit

class DashboardViewModel: ObservableObject {
    let store = HKHealthStore()
    
    @Published var isNotReady = false
    @Published var runningWorkouts: [HKWorkout] = []
    @Published var walkingWorkouts: [HKWorkout] = []
    @Published var cyclingWorkouts: [HKWorkout] = []
        
    var workouts: [HKWorkout]?
    
    func checkPermission() async {
        if !HKHealthStore.isHealthDataAvailable() {
            return
        }

        guard await requestPermission() == true else {
            return
        }
    }

    func requestPermission () async -> Bool {
        let write: Set<HKSampleType> = [.workoutType()]
        let read: Set = [
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
        ]

        let res: ()? = try? await store.requestAuthorization(toShare: write, read: read)
        guard res != nil else {
            return false
        }

        return true
    }
        
    func checkCurrentAuthorizationSetting() {
        // Request the current notification settings
        let currentSettings = store.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .heartRate)!)
        if currentSettings == .sharingAuthorized {
            self.isNotReady = false
        } else {
            self.isNotReady = true
        }
    }
    
    func latestHeartRate(startDate: Date, endDate: Date) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
//        let startDate = Calendar.current.date(byAdding: .hour, value: -6, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart:startDate, end: endDate, options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { sample, result, error in
            guard error == nil else {
                return
            }
            
            let unit = HKUnit(from: "count/min")
            
            guard let realResult = result else {return}
            for singleResult in realResult {
                let data = singleResult as! HKQuantitySample
                let latestHr = data.quantity.doubleValue(for: unit)
                print("latest hr \(latestHr) BPM")

                
                let dateFormator = DateFormatter()
                dateFormator.dateFormat = "dd/MM/yyyy hh:mm: s"
                
                let startdate1 = dateFormator.string(from: data.startDate)
                let enddate1 = dateFormator.string(from: data.endDate)
                print("start data: \(startdate1)")
                print("end date: \(enddate1)")
            }
        }
        
        store.execute(query)
    }
    
    private func runQuery(predicate: NSPredicate) async -> [HKSample] {
        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            store.execute(HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: 10,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }))
        }
        
        return samples
    }
    
    func readRunningWorkouts() async {
        let runningWorkouts = HKQuery.predicateForWorkouts(with: .running)
        
        let samplesRunning = await runQuery(predicate: runningWorkouts)
        DispatchQueue.main.async {
            self.runningWorkouts = samplesRunning as! [HKWorkout]
        }
    }
    
    func readIndoorRunningWorkouts() async {
        let runningWorkouts = HKQuery.predicateForWorkouts(with: .running)
        
        let samplesRunning = await runQuery(predicate: runningWorkouts)
        DispatchQueue.main.async {
            self.runningWorkouts = samplesRunning as! [HKWorkout]
        }
    }
    
    
    
    func readWalkingWorkouts() async {
        let walkingWorkouts = HKQuery.predicateForWorkouts(with: .walking)
        
        let samplesWalking = await runQuery(predicate: walkingWorkouts)
        DispatchQueue.main.async {
            self.walkingWorkouts = samplesWalking as! [HKWorkout]
        }
    }
    
    func readCyclingWorkouts() async {
        let cyclingWorkouts = HKQuery.predicateForWorkouts(with: .cycling)

        let samplesCycling = await runQuery(predicate: cyclingWorkouts)
        DispatchQueue.main.async {
            self.cyclingWorkouts = samplesCycling as! [HKWorkout]
        }
    }
    
    func loadWorkoutData() async {
        await readRunningWorkouts()
        await readWalkingWorkouts()
        await readCyclingWorkouts()
    }
}
