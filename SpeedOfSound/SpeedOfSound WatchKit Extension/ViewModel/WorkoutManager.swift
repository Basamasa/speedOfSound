//
//  WorkoutManager.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 25.04.22.
//

import Foundation
import HealthKit
import CoreMotion
import WatchKit
import UserNotifications
import SwiftUI
import AVFoundation

enum WorkoutState {
    case running
    case paused
    case ended
}

class WorkoutManager: NSObject, ObservableObject {
    var wcsessionManager = SessionManager()
    var selectedWorkout: WorkoutType?
    var workoutState: WorkoutState = .ended
    
    // Workout state
    @Published var running = false
    
    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    
    // Workout data
    @Published var workoutModel = WorkoutModel()
    var countTimer: ParkBenchTimer?
    var timeCountList: [CFAbsoluteTime] = []
    
    // Pedometer(Cadence)
    let pedometer = CMPedometer()
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var selectedCadence: Int = 120
    @Published var selectedCadenceStyle: CadenceStyle = .average
    @Published var currentCadence: Int = 0
    @Published var averageCadence: Int = 0
    @Published var highestCadence: Int = 0
    @Published var showCadenceSheet: Bool = false
    var cadenceList: [Int] = []
    
    // Feedback
    @Published var showTooHighFeedback: Bool = false
    @Published var showTooLowFeedback: Bool = false
    private var maxBounds: Int = 0
    private var minBounds: Int = 0
    
    // Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0 {
        didSet {
            lastHeartRate = oldValue
            giveNotificationFeedback()
        }
    }
    var lastHeartRate: Double = 0

    @Published var steps: Double = 0
    @Published var averageSteps: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    // MARK: - Cadence calculation
    var isCadenceAvailable : Bool {
        get{
            return CMPedometer.isCadenceAvailable()
        }
    }
    
    func startTrackingSteps() {
        startCadenceWorkout()
        pedometer.startUpdates(from: Date(), withHandler:
                 { (pedometerData, error) in
            if let pedData = pedometerData {
                let currentCadence = Int(truncating: pedData.currentCadence ?? 0) * 60
                self.currentCadence = currentCadence
                self.cadenceList.append(currentCadence)
                if currentCadence > self.highestCadence {
                    self.highestCadence = currentCadence
                }
            }
        })
    }
    
    func startCadenceWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        } catch {
            return
        }
        
        session?.delegate = self

        let startDate = Date()
        session?.startActivity(with: startDate)
    }
    
    func endCadenceWorkout() {
        if !cadenceList.isEmpty {
            var sum = 0
            for cadence in cadenceList {
                sum += cadence
            }
            averageCadence = Int(sum / cadenceList.count)
        }
        
        session?.end()
        pedometer.stopUpdates()
        WKInterfaceDevice.current().play(.success)
        timer.upstream.connect().cancel()
        cadenceList = []
    }
    
    func cadenceWorkoutSelected() {
        if selectedCadenceStyle == .average {
            selectedCadence = averageCadence
        } else if selectedCadenceStyle == .highest {
            selectedCadence = highestCadence
        }
        
        showCadenceSheet = false
    }
    
    // MARK: - Workout
    
    func giveNotificationFeedback() {
//        guard workoutModel.feedback == .notification else {return}
        
        if Int(heartRate) > workoutModel.highBPM { // Hihger than the zone
            if maxBounds >= 2 {
                showTooHighFeedback = true
                WKInterfaceDevice.current().play(.notification)
//                speechSentence("Slow Down")
                maxBounds = 0
                workoutModel.numberOfFeedback += 1
                countTimer = ParkBenchTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.showTooHighFeedback = false
                }
            }
            maxBounds += 1
        } else if Int(heartRate) < workoutModel.lowBPM { // Lower than the zone
            if minBounds >= 2 {
                showTooLowFeedback = true
                WKInterfaceDevice.current().play(.notification)
//                speechSentence("Speed Up")
                minBounds = 0
                workoutModel.numberOfFeedback += 1
                countTimer = ParkBenchTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.showTooLowFeedback = false
                }
            }
            minBounds += 1
        } else {
            if (Int(lastHeartRate) < workoutModel.lowBPM) || (Int(lastHeartRate) > workoutModel.highBPM) {
                if let timer = countTimer?.stop() {
                    print("******** Just took \(timer) seconds ********")
                    timeCountList.append(timer)
                }
            }
        }
    }
    
    func speechSentence(_ text: String) {
       try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [])
       var utterance: AVSpeechUtterance!
       let synthesizer = AVSpeechSynthesizer()
       utterance = AVSpeechUtterance(string: text)
       utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
       utterance.rate = AVSpeechUtteranceDefaultSpeechRate
       synthesizer.speak(utterance)
   }
    
    func selectedOneWorkout(workoutType: WorkoutType) {
        selectedWorkout = workoutType
        if workoutType == .outdoorWalking || workoutType == .outdoorRunning {
            if workoutType == .outdoorRunning {
                startWorkout(workoutType: HKWorkoutActivityType.running, locationType: .outdoor)
            } else if workoutType == .outdoorWalking {
                startWorkout(workoutType: HKWorkoutActivityType.walking, locationType: .outdoor)
            }
        } else {
            if workoutType == .indoorRunning {
                startWorkout(workoutType: HKWorkoutActivityType.running, locationType: .indoor)
            } else if workoutType == .indoorWalking {
                startWorkout(workoutType: HKWorkoutActivityType.walking, locationType: .indoor)
            }
        }
        wcsessionManager.workSessionBegin(isSoundFeedback: workoutModel.feedback == .sound)
        wcsessionManager.sendWorkOutModel(workoutModel.getData)
    }
    
    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType, locationType: HKWorkoutSessionLocationType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = locationType

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }

//        let metadata : NSDictionary = [
//            HKMetadataKeyWorkoutBrandName: workoutModel.getData,
//        ]
//
//        builder?.addMetadata(metadata as! [String : String]) { (success, error) in
//        }
        session?.delegate = self
        builder?.delegate = self

        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)

        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
        }
    }

    func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.activitySummaryType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }

    // MARK: - Session State Control

    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }

    func pause() {
        session?.pause()
        wcsessionManager.workSessionEnd()
    }

    func resume() {
        session?.resume()
        wcsessionManager.workSessionBegin(isSoundFeedback: workoutModel.feedback == .sound)
    }

    func endWorkout() {
        calculateAverageTimeGoingBackToZone()
        session?.end()
        showingSummaryView = true
        wcsessionManager.workSessionEnd()
    }

    // MARK: - Workout Metrics

    func calculateAverageTimeGoingBackToZone() {
        guard !timeCountList.isEmpty else { return }
        let average = Int(timeCountList.reduce(0, +)) / timeCountList.count
        workoutModel.meanTimeNeededGetBackToZone = average
    }
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.wcsessionManager.bpmchanged(Int(self.heartRate))
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                let stepsUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.steps = statistics.mostRecentQuantity()?.doubleValue(for: stepsUnit) ?? 0
                self.averageSteps = statistics.averageQuantity()?.doubleValue(for: stepsUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }

    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        workout = nil
        session = nil
        steps = 0
        averageSteps = 0
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
        workoutModel.numberOfFeedback = 0
        workoutModel.numberOfGotLooked = 0
        workoutModel.meanTimeNeededGetBackToZone = 0
        timeCountList = []
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            let metadata : NSDictionary = [
                HKMetadataKeyWorkoutBrandName: workoutModel.getData,
            ]
            
            builder?.addMetadata(metadata as! [String : String]) { (success, error) in
            }
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
            DispatchQueue.main.async {
                self.workoutState = .ended
            }
        } else if toState == .running {
            DispatchQueue.main.async {
                self.workoutState = .running
            }
        } else if toState == .paused {
            DispatchQueue.main.async {
                self.workoutState = .paused
            }
        }
    }
    
//    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
//        switch event.type {
//        case .motionPaused:
//            WKInterfaceDevice.current().play(.stop)
//            pause()
//        case .motionResumed:
//            WKInterfaceDevice.current().play(.start)
//            resume()
//        default: break
//        }
//    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            if workoutState == .running {
                updateForStatistics(statistics)
            }
        }
    }
}

class ParkBenchTimer {
    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?

    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()

        return duration!
    }

    var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
