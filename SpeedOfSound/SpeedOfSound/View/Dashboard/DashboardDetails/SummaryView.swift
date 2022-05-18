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
            SummaryTitleWorkouts(type: rowDetailsViewModel.detailsModel.type, detailsModel: rowDetailsViewModel.detailsModel)
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Heart Rate Summary")
                    .bold()
                HorizontalBarChartView(dataPoints: rowDetailsViewModel.heartRatePercetages)
                    .frame(maxWidth: UIScreen.main.bounds.maxX - 50)
            }
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
        .padding()
    }
}

struct SummaryTitleWorkouts: View {
    let type: HKWorkoutActivityType
    var detailsModel: WorktoutDetailsModel

    var body: some View {
        HStack(spacing: 3) {
            Image(type.associatedImageName)
                .resizable()
                .foregroundColor(Color(UIColor.systemGray))
                .frame(width: 80, height: 80, alignment: .center)
            VStack(alignment: .leading) {
                Text(detailsModel.indoorWorktoutMeta)
                    .bold()
                    .foregroundColor(Color("Main")) +
                Text(type.name)
                    .bold()
                    .foregroundColor(Color("Main"))
                HStack(alignment: .center, spacing: 5) {
                    Text(detailsModel.startTime)
                        .workoutSubheadlineStyle()
                    Text("-")
                        .workoutSubheadlineStyle()
                    Text(detailsModel.endTime)
                        .workoutSubheadlineStyle()
                }
            }
            .padding()
        }
        .font(Font.body.bold())
    }
}

struct DurationEneryView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var duration: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Duration")
//                .bold()
//                .foregroundColor(Color("Main"))
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
                .workoutTitleStyleRed()
            + Text(" -- ")
                .workoutSubheadlineStyle()
            + Text("\(rowDetailsViewModel.detailsModel.highBPM)")
                .workoutTitleStyleRed()
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
                Text("Choosed Feedback")
                    .bold()
//                    .foregroundColor(Color("Main"))
                Text("\(rowDetailsViewModel.detailsModel.feedbackStyle)")
                    .workoutTitleStyle()
            }
            Spacer()
        }
    }
}
