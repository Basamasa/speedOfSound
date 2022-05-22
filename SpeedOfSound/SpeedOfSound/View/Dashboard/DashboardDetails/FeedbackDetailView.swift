//
//  FeedbackDetailView.swift
//  MetronomeZones
//
//  Created by Anzer Arkin on 22.05.22.
//

import SwiftUI
import HealthKit
import SwiftUICharts

struct FeedbackDetailView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                VStack {
                    MultiLineChart(chartData: rowDetailsViewModel.multiLinChartData)
                        .touchOverlay(chartData: rowDetailsViewModel.multiLinChartData, specifier: "%.01f", unit: .suffix(of: "BPM"))
//                        .pointMarkers(chartData: rowDetailsViewModel.multiLinChartData)
                        .xAxisGrid(chartData: rowDetailsViewModel.multiLinChartData)
                        .yAxisGrid(chartData: rowDetailsViewModel.multiLinChartData)
                        .xAxisLabels(chartData: rowDetailsViewModel.multiLinChartData)
                        .yAxisLabels(chartData: rowDetailsViewModel.multiLinChartData, specifier: "%.01f")
                        .floatingInfoBox(chartData: rowDetailsViewModel.multiLinChartData)
                        .headerBox(chartData: rowDetailsViewModel.multiLinChartData)
                        .legends(chartData: rowDetailsViewModel.multiLinChartData, columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])
                        .id(rowDetailsViewModel.multiLinChartData.id)
                        .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Feedback details")
        .onAppear() {
            
        }
    }
    
    static func weekOfData() -> MultiLineChartData {
            let data = MultiLineDataSet(dataSets: [
                LineDataSet(dataPoints: [
                    LineChartDataPoint(value: 4.3,  xAxisLabel: "J", description: "January"),
                    LineChartDataPoint(value: 4.5,  xAxisLabel: "F", description: "February"),
                    LineChartDataPoint(value: 6.9,  xAxisLabel: "M", description: "March"),
                    LineChartDataPoint(value: 8.7,  xAxisLabel: "A", description: "April"),
                    LineChartDataPoint(value: 12.1, xAxisLabel: "M", description: "May"),
                    LineChartDataPoint(value: 15.1, xAxisLabel: "J", description: "June"),
                    LineChartDataPoint(value: 17.3, xAxisLabel: "J", description: "July"),
                    LineChartDataPoint(value: 17.0, xAxisLabel: "A", description: "August"),
                    LineChartDataPoint(value: 14.3, xAxisLabel: "S", description: "September"),
                    LineChartDataPoint(value: 10.9, xAxisLabel: "O", description: "October"),
                    LineChartDataPoint(value: 7.2,  xAxisLabel: "N", description: "November"),
                    LineChartDataPoint(value: 4.7,  xAxisLabel: "D", description: "December")
                ],
                legendTitle: "London",
                pointStyle: PointStyle(pointType: .outline, pointShape: .circle),
                style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line)),
                
                LineDataSet(dataPoints: [
                    LineChartDataPoint(value: 16.9, xAxisLabel: "J", description: "January"),
                    LineChartDataPoint(value: 17.2, xAxisLabel: "F", description: "February"),
                    LineChartDataPoint(value: 15.8, xAxisLabel: "M", description: "March"),
                    LineChartDataPoint(value: 13.7, xAxisLabel: "A", description: "April"),
                    LineChartDataPoint(value: 11.7, xAxisLabel: "M", description: "May"),
                    LineChartDataPoint(value: 9.7,  xAxisLabel: "J", description: "June"),
                    LineChartDataPoint(value: 8.9,  xAxisLabel: "J", description: "July"),
                    LineChartDataPoint(value: 9.4,  xAxisLabel: "A", description: "August"),
                    LineChartDataPoint(value: 10.8, xAxisLabel: "S", description: "September"),
                    LineChartDataPoint(value: 12.0, xAxisLabel: "O", description: "October"),
                    LineChartDataPoint(value: 13.5, xAxisLabel: "N", description: "November"),
                    LineChartDataPoint(value: 15.4, xAxisLabel: "D", description: "December")
                ],
                legendTitle: "Wellington",
                pointStyle: PointStyle(pointType: .outline, pointShape: .square),
                style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line)),
            ])
            
            return MultiLineChartData(dataSets: data,
                                      metadata: ChartMetadata(title: "Average Temperature", subtitle: "Monthly"),
                                      xAxisLabels: ["January", "December"],
                                      chartStyle: LineChartStyle(infoBoxPlacement: .floating,
                                                                 markerType: .full(attachment: .line(dot: .style(DotStyle()))),
                                                                 xAxisGridStyle: GridStyle(numberOfLines: 12),
                                                                 xAxisTitle: "Month",
                                                                 yAxisGridStyle: GridStyle(numberOfLines: 5),
                                                                 yAxisNumberOfLabels: 5,
                                                                 yAxisTitle: "Temperature (ºc)",
                                                                 baseline: .minimumValue,
                                                                 topLine: .maximumValue))
        }
}
