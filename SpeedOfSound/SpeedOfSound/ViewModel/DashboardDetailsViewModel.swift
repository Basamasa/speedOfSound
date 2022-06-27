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
    var hearRatePercentageData = DoughnutChartData(dataSets:
                                                    PieDataSet(dataPoints:
                                                                [PieChartDataPoint(value: 1, description: "No data"  , colour: .red  , label: .label(text: "No data"  , rFactor: 0.8))], legendTitle: "A"), metadata: ChartMetadata(title: "Doughnut", subtitle: "mmm doughnuts"), chartStyle: DoughnutChartStyle(infoBoxPlacement: .header), noDataText: Text("No data"))
    @Published var multiLinChartData = MultiLineChartData(dataSets: MultiLineDataSet(dataSets: []))
    let detailsModel: WorktoutDetailsModel
    @Published var steps: Int = 0
    @Published var meanCorrectionTime: Int = 0
    
    var averageCadence: Int {
        steps / Int(detailsModel.workout.duration) * 60
    }
    
    init(workout: HKWorkout) {
        self.detailsModel = WorktoutDetailsModel(workout: workout)
    }
    
    private func getPercentageValue(upNumber: Double, downNumber: Double) -> Double {
        if downNumber == 0 {
            return 0
        }
        let x = upNumber / downNumber * 100
        return x.round(to: 1)
    }
    
    // MARK: - Heart rate
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
            self.hearRatePercentageData = self.makePercentageGraph(low: lowHeartRatePercentage, high: highHeartRatePercentage, inside: insideHeartRatePercentage, heartRateCount: Double(results.count))
        }
    }
    
    // MARK: - Pie graph
    private func makePercentageGraph(low: Double, high: Double, inside: Double, heartRateCount: Double) -> DoughnutChartData {
        let lowPercentage = getPercentageValue(upNumber: low, downNumber: heartRateCount)
        let insidePercentage = getPercentageValue(upNumber: inside, downNumber: heartRateCount)
        let highPercentage = getPercentageValue(upNumber: high, downNumber: heartRateCount)
        if heartRateCount == 0 {
            return hearRatePercentageData
        }
        let data = PieDataSet(
            dataPoints: [
                PieChartDataPoint(value: lowPercentage, description: "Lower \(lowPercentage)%"  , colour: .yellow  , label: .label(text: "Lower"  , rFactor: 0.8)),
                PieChartDataPoint(value: insidePercentage, description: "Inside \(insidePercentage)%"  , colour: .green   , label: .label(text: "Inside"  , rFactor: 0.8)),
                PieChartDataPoint(value: highPercentage, description: "Higher \(highPercentage)%", colour: .red, label: .label(text: "Higher", rFactor: 0.8))],
            legendTitle: "Data")

        return DoughnutChartData(dataSets: data,
                                 metadata: ChartMetadata(title: "Doughnut", subtitle: "mmm doughnuts"),
                                 chartStyle: DoughnutChartStyle(infoBoxPlacement: .header),
                                 noDataText: Text("hello"))
    }
    
    // MARK: - Multi graph
    
    private func createSoundFeedbackData(results: [Double]) -> [Double] {
        var data: [Double] = []
        var lowHeartRates: Int = 0
        var highHeartRates: Int = 0
        var numberOutOfRange: Int = 0
        var type: ValueType = .inside
        enum ValueType {
            case higher
            case inside
            case lower
        }
        for value in results {
            if value > Double(detailsModel.highBPM) { // Hihger than the zone
                if type != .higher {
                    numberOutOfRange += 1
                }
                type = .higher
                highHeartRates += 1
            } else if value < Double(detailsModel.lowBPM) { // Lower than the zone
                if type != .lower {
                    numberOutOfRange += 1
                }
                type = .lower
                lowHeartRates += 1
            } else {
                type = .inside
            }
            data.append(Double(detailsModel.cadence))
        }
        DispatchQueue.main.async {
            self.meanCorrectionTime = (lowHeartRates + highHeartRates) / numberOutOfRange
        }
        
        return data
    }
    
    private func makeMultiGraph(results: [Double]) {
        var dataPoints: [LineChartDataPoint] = []
        var feedbackDataPoints: [LineChartDataPoint] = []
        let feedbackDatas = createSoundFeedbackData(results: results)
        
        for (index, value) in results.enumerated() {
            var feedbackData: Double = 0
            if feedbackDatas.count == results.count {
                feedbackData = feedbackDatas[index]
            }
            if index == results.count - 1 {
                dataPoints.append(LineChartDataPoint(value: value, xAxisLabel: "Last", description: ""))
                feedbackDataPoints.append(LineChartDataPoint(value: feedbackData, xAxisLabel: "Last", description: ""))
            } else {
                dataPoints.append(LineChartDataPoint(value: value, xAxisLabel: "", description: ""))
                feedbackDataPoints.append(LineChartDataPoint(value: feedbackData, xAxisLabel: "", description: ""))
            }
        }
        
        let data = MultiLineDataSet(dataSets: [
            LineDataSet(dataPoints: dataPoints,
                        legendTitle: "Heart rate",
                       pointStyle: PointStyle(pointType: .outline, pointShape: .circle),
                       style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line)),
            LineDataSet(dataPoints: feedbackDataPoints,
                        legendTitle: "Start Cadence",
                       pointStyle: PointStyle(pointType: .outline, pointShape: .circle),
                        style: LineStyle(lineColour: ColourStyle(colour: .yellow), lineType: .line))])
        DispatchQueue.main.async {
            self.multiLinChartData = MultiLineChartData(dataSets: data,
                                                        metadata: ChartMetadata(title: "Feedback with heart rate", subtitle: "Difference"),
                                                        xAxisLabels: ["January", "December"],
                                                        chartStyle: LineChartStyle(infoBoxPlacement: .floating,
                                                                                   markerType: .full(attachment: .line(dot: .style(DotStyle()))),
                                                                                   xAxisGridStyle: GridStyle(numberOfLines: 12),
                                                                                   xAxisTitle: "Time",
                                                                                   yAxisGridStyle: GridStyle(numberOfLines: 5),
                                                                                   yAxisNumberOfLabels: 5,
                                                                                   yAxisTitle: "BPM",
                                                                                   baseline: .minimumValue,
                                                                                   topLine: .maximumValue))
        }
    }
    
    func getHeartRates() {
        detailsModel.getHeartRates() { results in
            self.heartRatesChanged(results: results)
            self.makeMultiGraph(results: results)
        }
    }
    
    func getSteps() {
        detailsModel.getSteps() { results in
            DispatchQueue.main.async {
                self.steps = Int(results)
            }
        }
    }
}
