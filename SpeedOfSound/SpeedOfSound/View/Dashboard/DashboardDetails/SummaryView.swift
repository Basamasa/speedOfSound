//
//  SummaryView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI
import HealthKit
import SwiftUICharts

struct SummaryView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            FeedbackView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            
            RangeCadenceView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            
            DurationEneryView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            
            DistanceStepsView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Heart Rate Summary")
                    .bold()
                VStack {
                    DoughnutChart(chartData: rowDetailsViewModel.heartRatePercetages)
                        .touchOverlay(chartData: rowDetailsViewModel.heartRatePercetages)
//                        .headerBox(chartData: rowDetailsViewModel.heartRatePercetages)
                        .legends(chartData: rowDetailsViewModel.heartRatePercetages, columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])
                        .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                        .id(rowDetailsViewModel.heartRatePercetages.id)
                        .padding(.vertical)
                }
                .frame(height: 150)
//                .offset(y: 20)
//                HorizontalBarChartView(dataPoints: rowDetailsViewModel.heartRatePercetages)
//                    .frame(maxWidth: UIScreen.main.bounds.maxX - 50)
            }
        }
        .cardStyle()
        .padding([.leading, .trailing])
        .offset(y: -80)
    }
}

struct DurationEneryView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var duration: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Duration")
            Text("\(rowDetailsViewModel.detailsModel.getDuration().0)")
                .workoutTitleYellow()
            + Text(" hr ")
                .workoutSubheadlineStyle()
            + Text("\(rowDetailsViewModel.detailsModel.getDuration().1)")
                .workoutTitleYellow()
            + Text(" min")
                .workoutSubheadlineStyle()
            + Text(" \(rowDetailsViewModel.detailsModel.getDuration().2)")
                .workoutTitleYellow()
            + Text(" sec")
                .workoutSubheadlineStyle()
        }
    }
    
    var energyBurned: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Enery Burned")
            Text(rowDetailsViewModel.detailsModel.energyBurned)
                .workoutTitlBlue()
            + Text(" kcal")
                    .workoutSubheadlineStyle()
        }
    }
    
    var body: some View {
        HStack {
            duration
            Spacer()
            energyBurned
        }
    }
}

struct DistanceStepsView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Distance")
                Text(rowDetailsViewModel.detailsModel.distance)
                    .workoutTitlCyan()
                + Text(" km")
                    .workoutSubheadlineStyle()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("Steps")
                Text("\(rowDetailsViewModel.steps)")
                    .workoutTitleStyle()
                + Text(" steps")
                    .workoutSubheadlineStyle()
            }
        }
    }
}

struct RangeCadenceView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var cadence: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Start Cadence")
            Text("\(rowDetailsViewModel.detailsModel.cadence)")
                .workoutTitleStyle()
            + Text(" SPM")
                .workoutSubheadlineStyle()
        }
    }
    
    var range: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Heart rate zone")
            Text("\(rowDetailsViewModel.detailsModel.lowBPM)")
                .workoutTitleLowZone()
            + Text(" -- ")
                .workoutSubheadlineStyle()
            + Text("\(rowDetailsViewModel.detailsModel.highBPM)")
                .workoutTitleHighZone()
            + Text(" BPM")
                .workoutSubheadlineStyle()
        }
    }
    var body: some View {
        HStack {
            cadence
            Spacer()
            range
        }
    }
}

struct FeedbackView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Chosen Feedback")
                    .bold()
                Text("\(rowDetailsViewModel.detailsModel.feedbackStyle)")
                    .workoutTitleRed()
            }
            Spacer()
        }
    }
}
