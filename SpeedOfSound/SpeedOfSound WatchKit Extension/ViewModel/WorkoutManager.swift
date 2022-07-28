//
//  WorkoutManager.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 25.04.22.
//

import Foundation
import HealthKit
import WatchKit
import UserNotifications
import SwiftUI
import AVFoundation

enum WorkoutState {
    case running
    case paused
    case ended
}

final class WorkoutManager: NSObject, ObservableObject {
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
    var timeList_for_back_to_zone: [CFAbsoluteTime] = []
    var heartRateTimer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()

    // Feedback
    @Published var showTooHighFeedback: Bool = false
    @Published var showTooLowFeedback: Bool = false
    
    // Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0

    @Published var steps: Double = 0
    @Published var averageSteps: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    // MARK: - Workout
    
   func speechSentence(_ text: String) {
       try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [])
       var utterance: AVSpeechUtterance!
       let synthesizer = AVSpeechSynthesizer()
       utterance = AVSpeechUtterance(string: text)
       utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
       utterance.rate = AVSpeechUtteranceDefaultSpeechRate
       synthesizer.speak(utterance)
   }
    
    enum Feedback {
        case slow
        case quick
    }
    
    private func giveFeedback(feedback: Feedback) {
        if workoutModel.feedback == .notification {
            if feedback == .quick {
                WKInterfaceDevice.current().play(.failure)
                
            } else if feedback == .slow {
                WKInterfaceDevice.current().play(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    WKInterfaceDevice.current().play(WKHapticType.success)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    WKInterfaceDevice.current().play(WKHapticType.success)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    WKInterfaceDevice.current().play(WKHapticType.success)
                }
            }
        } else if workoutModel.feedback == .appleWatchSound {
            if feedback == .quick {
                speechSentence("Let's slow down")
            } else if feedback == .slow {
                speechSentence("Let's speed up")
            }
        }
        workoutModel.numberOfFeedback += 1
    }
    func checkHeartRateWithFeedback() {
//        guard workoutModel.feedback == .notification else {return}
        if Int(heartRate) > workoutModel.highBPM { // Hihger than the zone
            giveFeedback(feedback: .quick)
        } else if Int(heartRate) < workoutModel.lowBPM { // Lower than the zone
            giveFeedback(feedback: .slow)
        }
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
    }

    func endWorkout() {
        session?.end()
        showingSummaryView = true
        wcsessionManager.workSessionEnd()
    }

    // MARK: - Workout Metrics
    
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
        timeList_for_back_to_zone = []
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
