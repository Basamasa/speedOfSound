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
            
            AgeView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            
            NumberOfTimesView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            
            RangeCadenceView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            
//            DistanceStepsView(rowDetailsViewModel: rowDetailsViewModel)
//            Divider()
//                .background(Color(UIColor.systemGray2))
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Heart Rate Summary")
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
    
    var age: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Age")
            Text("\(rowDetailsViewModel.detailsModel.age)")
                .workoutTitlCyan()
            + Text(" years old")
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
                        Text("\(rowDetailsViewModel.detailsModel.feedbackStyle): \(rowDetailsViewModel.detailsModel.cadence) BPM")
                            .bold()
                            .font(.body)
                            .foregroundColor(.white)
//                        Image(systemName: "chart.xyaxis.line")
//                            .foregroundColor(.white)
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
//            cadence
            age
        }
    }
}

struct AgeView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var average: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Mean Correction Time")
            Text("\(rowDetailsViewModel.detailsModel.meanTimeNeededGetBackToZone)")
                .workoutTitleRed()
            + Text(" seconds")
                .workoutSubheadlineStyle()
        }
    }
    
    
    var restingHeartRate: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Resting Heart Rate")
            Text("\(rowDetailsViewModel.detailsModel.restingHeartRate)")
                .workoutTitleRed()
            + Text(" BPM")
                    .workoutSubheadlineStyle()
        }
    }
    
    var body: some View {
        HStack {
            average
            Spacer()
            restingHeartRate
        }
    }
}

struct NumberOfTimesView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var numberOfTimes: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Number of Times Rising Wrist")
            Text("\(rowDetailsViewModel.detailsModel.numberOfTimeGotLooked)")
                .workoutTitleRed()
            + Text(" times")
                    .workoutSubheadlineStyle()
        }
    }
    
    var numberOfFeedback: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Number of Feedback Given")
            Text("\(rowDetailsViewModel.detailsModel.numberOfFeedback)")
                .workoutTitlBlue()
            + Text(" times")
                    .workoutSubheadlineStyle()
        }
    }
    
    var body: some View {
        HStack {
            numberOfFeedback
            Spacer()
            numberOfTimes
        }
    }
}

struct DistanceStepsView: View {
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
            duration
        }
    }
}

struct RangeCadenceView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var range: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Heart Rate Zone(Zone 2)")
            Text("\(rowDetailsViewModel.detailsModel.lowBPM)")
                .workoutTitleHighZone()
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
