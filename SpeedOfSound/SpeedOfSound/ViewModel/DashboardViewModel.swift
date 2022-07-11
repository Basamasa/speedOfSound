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
    
    var getPermission: Set<HKSampleType> {
        let write: Set<HKSampleType> = [.workoutType()]

        return write
    }
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
        let heartRatePermission = store.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .heartRate)!)

        if heartRatePermission == .sharingAuthorized {
            self.isNotReady = false
        } else {
            self.isNotReady = true
        }
    }
    
    private func runQuery(predicate: NSPredicate, withLimit: Int = 20) async -> [HKSample] {
        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            store.execute(HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: withLimit,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
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
    
    func loadAllRunningTest() async {
        let runningWorkouts = HKQuery.predicateForWorkouts(with: .running)

        let samplesRunning = await runQuery(predicate: runningWorkouts, withLimit: 100)
        DispatchQueue.main.async {
            let workouts = samplesRunning as! [HKWorkout]
            
            self.runningWorkouts = workouts.filter { workout in
                let minutes = Int(floor(workout.duration.truncatingRemainder(dividingBy: 3600)) / 60)
                if minutes > 15 {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    
    func loadAllRunningWorkouts() async {
        let runningWorkouts = HKQuery.predicateForWorkouts(with: .running)

        let samplesRunning = await runQuery(predicate: runningWorkouts, withLimit: 100)
        DispatchQueue.main.async {
            let workouts = samplesRunning as! [HKWorkout]

            self.walkingWorkouts = workouts
        }
    }
    
    func loadAllWalkingWorkouts() async {
        let runningWorkouts = HKQuery.predicateForWorkouts(with: .walking)

        let samplesRunning = await runQuery(predicate: runningWorkouts, withLimit: 100)
        DispatchQueue.main.async {
            self.walkingWorkouts = samplesRunning as! [HKWorkout]
        }
    }
    
    func readRunningWorkouts() async {
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
        await loadAllRunningTest()
        await loadAllRunningWorkouts()
//        await readRunningWorkouts()
//        await readWalkingWorkouts()
//        await readCyclingWorkouts()
    }
}

enum WorkoutType: String, Identifiable {
    var id: RawValue { rawValue }

    
    case outdoorRunning = "Outdoor running"
    case indoorRunning = "Indoor running"
    case outdoorWalking = "Outdoor walking"
    case indoorWalking = "Indoor walking"
    
    var name: String {
        switch self {
        case .outdoorRunning:
            return "Outdoor Run"
        case .indoorRunning:
            return "Indoor run"
        case .outdoorWalking:
            return "Outdoor walk"
        case .indoorWalking:
            return "Indoor walk"
        }
    }
    
    var imagName: String {
        switch self {
        case .outdoorRunning:
            return "running"
        case .indoorRunning:
            return "running"
        case .outdoorWalking:
            return "walking"
        case .indoorWalking:
            return "walking"
        }
    }
}
