//
//  RowDetailsViewModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 06.05.22.
//
import HealthKit
import SwiftUICharts
import SwiftUI

class DashboardDetailsViewModel: ObservableObject {
    let store = HKHealthStore()
    @Published var heartRateData: LineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
    
//    @Published var heartRatePoints: [DataPoint] = []
//    var heartRatePercetages: [DataPoint] = []
    var heartRateValues: [Double] = []
    let detailsModel: WorktoutDetailsModel
    
    @Published var steps: Int = 0
    
    init(workout: HKWorkout) {
        self.detailsModel = WorktoutDetailsModel(workout: workout)
    }
    
    private func getPercentageValue(upNumber: Double, downNumber: Double) -> String {
        let x = upNumber &/ Double(downNumber)
        let y = Double(round(1000 * x) / 1000)
        return "\(y * 100)"
    }
    
    private func heartRatesChanged(results: [Double]) {
        var dataPoints: [LineChartDataPoint] = []
        var lowHeartRatePercentage: Double = 0
        var insideHeartRatePercentage: Double = 0
        var highHeartRatePercentage: Double = 0
        var min: Double = Double(Int.max)
        var max: Double = 0
        
        for (index, value) in results.enumerated() {
            if index == results.count / 4 {
                dataPoints.append(LineChartDataPoint(value: value, xAxisLabel: "1", description: ""))
            } else if index == results.count / 4 * 2 {
                dataPoints.append(LineChartDataPoint(value: value, xAxisLabel: "2", description: ""))
            } else if index == results.count / 4 * 3 {
                dataPoints.append(LineChartDataPoint(value: value, xAxisLabel: "3", description: ""))
            } else if index == results.count - 1 {
                dataPoints.append(LineChartDataPoint(value: value, xAxisLabel: "4", description: ""))
            } else {
                dataPoints.append(LineChartDataPoint(value: value, xAxisLabel: "", description: ""))
            }
            
            if min < value {
                min = value
            }
            if max > value {
                max = value
            }
            
            if value < Double(detailsModel.lowBPM) {
                lowHeartRatePercentage += 1
            } else if value > Double(detailsModel.highBPM) {
                highHeartRatePercentage += 1
            } else {
                insideHeartRatePercentage += 1
            }
        }
        if min > Double(detailsModel.lowBPM) {
            min = Double(detailsModel.lowBPM)
        }
        if max < Double(detailsModel.highBPM) {
            max = Double(detailsModel.highBPM)
        }
        
        let data = LineDataSet(dataPoints: dataPoints,
                               legendTitle: "Heart rate",
                               pointStyle: PointStyle(),
                               style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
            
        let metadata = ChartMetadata(title: "Heart rate summary", subtitle: detailsModel.indoorWorktoutMeta + detailsModel.activityName)
            
        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 1,
                                   dash         : [8],
                                   dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                        infoBoxBorderColour : Color.primary,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        xAxisGridStyle      : gridStyle,
                                        xAxisLabelPosition  : .bottom,
                                        xAxisLabelColour    : Color.primary,
                                        xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.primary,
                                        yAxisNumberOfLabels : 7,
                                        baseline            : .minimumWithMaximum(of: min),
                                        topLine             : .maximum(of: max),
                                        globalAnimation     : .easeOut(duration: 1))
        DispatchQueue.main.async {
            self.heartRateData = LineChartData(dataSets: data, metadata: metadata, chartStyle: chartStyle)
        }
    }
        
    private func heartRatesChanged1(results: [Double]) {
//        var helperPoints: [DataPoint] = []
//        var percentagePoints: [DataPoint] = []
//        var lowHeartRatePercentage: Double = 0
//        var insideHeartRatePercentage: Double = 0
//        var highHeartRatePercentage: Double = 0
//        
//        for value in results {
//            if value < Double(detailsModel.lowBPM) {
//                let outsideRange = Legend(color: .yellow, label: "Below range", order: 1)
//                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
//                lowHeartRatePercentage += 1
//            } else if value > Double(detailsModel.highBPM) {
//                let outsideRange = Legend(color: .red, label: "Higher range", order: 2)
//                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
//                highHeartRatePercentage += 1
//            } else {
//                let outsideRange = Legend(color: .green, label: "Inside range", order: 0)
//                helperPoints.append(.init(value: value, label: "", legend: outsideRange))
//                insideHeartRatePercentage += 1
//            }
//        }
//        let heartRateCount = Double(results.count)
//        
//        let lowPercentage = getPercentageValue(upNumber: lowHeartRatePercentage, downNumber: heartRateCount)
//        let insidePercentage = getPercentageValue(upNumber: insideHeartRatePercentage, downNumber: heartRateCount)
//        let highPercentage = getPercentageValue(upNumber: highHeartRatePercentage, downNumber: heartRateCount)
//        
//        let belowRange = Legend(color: .yellow, label: "Below range \(lowPercentage) %", order: 1)
//        percentagePoints.append(.init(value: Double(getPercentageValue(upNumber: lowHeartRatePercentage, downNumber: heartRateCount)) ?? 0, label: "", legend: belowRange))
//        
//        let highRange = Legend(color: .red, label: "Higher range \(highPercentage) %", order: 0)
//        percentagePoints.append(.init(value: Double(getPercentageValue(upNumber: highHeartRatePercentage, downNumber: heartRateCount)) ?? 0, label: "", legend: highRange))
//        
//        let insideRange = Legend(color: .green, label: "Inside range \(insidePercentage) %", order: 2)
//        percentagePoints.append(.init(value: Double(getPercentageValue(upNumber: insideHeartRatePercentage, downNumber: heartRateCount)) ?? 0, label: "", legend: insideRange))
//        
//        DispatchQueue.main.async {
//            self.heartRatePoints = helperPoints
//            self.heartRatePercetages = percentagePoints
//        }
        
    }
    
    func getHeartRates() {
        detailsModel.getHeartRates() { results in
            self.heartRatesChanged(results: results)
        }
    }
    
    func getSteps() {
        detailsModel.getStepsFromPedome { results in
            DispatchQueue.main.async {
                self.steps = Int(results)
            }
        }
    }
}
