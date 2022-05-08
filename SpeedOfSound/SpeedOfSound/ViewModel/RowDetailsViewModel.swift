//
//  RowDetailsViewModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 06.05.22.
//
import HealthKit
import SwiftUICharts

class RowDetailsViewModel: ObservableObject {
    let store = HKHealthStore()

    @Published var runningWorkoutsHeartRate: [Double] = [] {
        didSet {
            heartRatesChanged()
        }
    }
    let startDate: Date
    let endDate: Date
    let lowRange: Double
    let highRange: Double
    var points: [DataPoint] = []
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        self.lowRange = 120
        self.highRange = 140
    }
    
    private func heartRatesChanged() {
        var helperPoints: [DataPoint] = []

        for value in runningWorkoutsHeartRate {
            if value < lowRange {
                let outsideRange = Legend(color: .gray, label: "Below range", order: 1)
                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
            } else if value > highRange {
                let outsideRange = Legend(color: .red, label: "Higher range", order: 2)
                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
            } else {
                let outsideRange = Legend(color: .green, label: "Inside range", order: 0)
                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
            }
        }
        points = helperPoints
    }
    
    func latestHeartRate() {
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
            DispatchQueue.main.async {
                self.runningWorkoutsHeartRate = results
            }
        }
        
        store.execute(query)
    }
}
