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
                    DoughnutChart(chartData: rowDetailsViewModel.hearRatePercentageData)
                        .touchOverlay(chartData: rowDetailsViewModel.hearRatePercentageData)
//                        .headerBox(chartData: rowDetailsViewModel.heartRatePercetages)
                        .legends(chartData: rowDetailsViewModel.hearRatePercentageData, columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])
                        .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                        .id(rowDetailsViewModel.hearRatePercentageData.id)
                        .padding(.vertical)
                }
                .frame(height: 150)
            }
        }
        .cardStyle()
        .padding([.leading, .trailing])
        .offset(y: -80)
    }
}

struct FeedbackView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var cadence: some View {
        VStack(alignment: .trailing, spacing: 5) {
            if rowDetailsViewModel.detailsModel.feedbackStyle == "Sound" {
                Text("Sound frequency")
            } else {
                Text("Start Cadence")
            }
            Text("\(rowDetailsViewModel.detailsModel.cadence)")
                .workoutTitleStyle()
            + Text(" BPM")
                .workoutSubheadlineStyle()
        }
    }
    
    var feedback: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Chosen Feedback")
                .bold()
            HStack {
//                Text("\(rowDetailsViewModel.detailsModel.feedbackStyle)")
//                    .workoutTitlBlue()
                NavigationLink(destination: FeedbackDetailView(rowDetailsViewModel: rowDetailsViewModel)) {
                    HStack {
                        Text("\(rowDetailsViewModel.detailsModel.feedbackStyle)")
                            .bold()
                            .font(.body)
                            .foregroundColor(.white)
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(.white)
                    }
                    .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .background(.blue)
                    .cornerRadius(45)
//                    .frame(width: 100, height: 49)
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            feedback
            Spacer()
            cadence
        }
    }
}

struct DurationEneryView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var duration: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Duration")
            HStack(spacing: 1) {
                if rowDetailsViewModel.detailsModel.getDuration().0 != 0 {
                    Text("\(rowDetailsViewModel.detailsModel.getDuration().0)")
                        .workoutTitleYellow()
                    Text(" hr ")
                        .workoutSubheadlineStyle()
                }
                if rowDetailsViewModel.detailsModel.getDuration().1 != 0 {
                    Text("\(rowDetailsViewModel.detailsModel.getDuration().1)")
                        .workoutTitleYellow()
                    Text(" min")
                        .workoutSubheadlineStyle()
                }
                Text(" \(rowDetailsViewModel.detailsModel.getDuration().2)")
                    .workoutTitleYellow()
                Text(" sec")
                    .workoutSubheadlineStyle()
            }
        }
    }
    
    var numberOfTimes: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Number of times rising wrist")
            Text("\(rowDetailsViewModel.detailsModel.numberOfTimeGotLooked)")
                .workoutTitleRed()
            + Text(" times")
                    .workoutSubheadlineStyle()
        }
    }
    
    var body: some View {
        HStack {
            duration
            Spacer()
            numberOfTimes
        }
    }
}

struct DistanceStepsView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var distance: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Distance")
            Text(rowDetailsViewModel.detailsModel.distance)
                .workoutTitlCyan()
            + Text(" km")
                .workoutSubheadlineStyle()
        }
    }
    
    var body: some View {
        HStack {
            distance
            Spacer()
        }
    }
}

struct RangeCadenceView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var range: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Heart Rate Zone(Zone 2)")
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
    
    var steps: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Average Cadence")
            Text("\(rowDetailsViewModel.averageCadence)")
                .workoutTitleStyle()
            + Text(" SPM")
                .workoutSubheadlineStyle()
        }
    }
    var body: some View {
        HStack {
            range
            Spacer()
            steps
        }
    }
}
