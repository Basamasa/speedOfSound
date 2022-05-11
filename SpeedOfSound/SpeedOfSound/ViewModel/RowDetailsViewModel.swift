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

    let lowRange: Double
    let highRange: Double
    @Published var heartRatePoints: [DataPoint] = []
    let detailsModel: WorktoutDetailsModel
    
    @Published var steps: [Double] = []
    
    init(workout: HKWorkout) {
        self.lowRange = 110
        self.highRange = 140
        self.detailsModel = WorktoutDetailsModel(workout: workout)
    }
    
    var activityName: String {
        return detailsModel.activityName
    }
    
    var distance: String {
        return detailsModel.distance
    }
    
    var durationHours: Int {
        return detailsModel.durationHours
    }
    
    var durationMinutes: Int {
        return detailsModel.durationMinutes
    }
    
    var energyBurned: String {
        return detailsModel.energyBurned
    }
    
    var type: HKWorkoutActivityType {
        return detailsModel.type
    }
        
    private func heartRatesChanged(results: [Double]) {
        var helperPoints: [DataPoint] = []

        for value in results {
            if value < lowRange {
                let outsideRange = Legend(color: .yellow, label: "Below range", order: 1)
                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
            } else if value > highRange {
                let outsideRange = Legend(color: .red, label: "Higher range", order: 2)
                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
            } else {
                let outsideRange = Legend(color: .green, label: "Inside range", order: 0)
                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
            }
        }
        DispatchQueue.main.async {
            self.heartRatePoints = helperPoints
        }
        
    }
    
    private func calculatePercentage() {
        
    }
    
    func getHeartRates() {
        detailsModel.getHeartRates() { results in
            self.heartRatesChanged(results: results)
        }
    }
    
    func getSteps() {
        detailsModel.getSteps { results in
            DispatchQueue.main.async {
                self.steps = results
            }
        }
    }
}
