//
//  WatchFaceModel.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 20.04.22.
//

import Foundation
import HealthKit
import WatchConnectivity
import Combine

class WatchFaceModel: ObservableObject {
    @Published var value = 0
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    // Work out session
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    // Watch connectivity
    var wcSession: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<Int, Never>()
    @Published private(set) var count: Int = 0
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject)
        self.wcSession = session
        self.wcSession.delegate = self.delegate
        self.wcSession.activate()
           
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
    }
    
    private func bpmchanged(_ count: Int) {
        value = count
        wcSession.sendMessage(["count": count], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func startCalculateHeartRate() {
        autorizeHealthKit()
        startSession()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    func startSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle failure here.
            return
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)
        
        session?.startActivity(with: Date())
        builder?.beginCollection(withStart: Date()) { (success, error) in
            
            guard success else {
                return
            }
            
            // Indicate that the session has started.
        }
    }
    
    func endSession() {
        session?.end()
        builder?.endCollection(withEnd: Date()) { (success, error) in
            
            guard success else {
                return
            }
            
            self.builder?.finishWorkout { (workout, error) in
                
                guard workout != nil else {
                    return
                }
                
                DispatchQueue.main.async() {
                    // Update the user interface.
                }
            }
        }
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
                // 3
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            self.process(samples, type: quantityTypeIdentifier)
        }
        
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // 5
        
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.value = Int(lastHeartRate)
            bpmchanged(Int(lastHeartRate))
        }
    }
}
