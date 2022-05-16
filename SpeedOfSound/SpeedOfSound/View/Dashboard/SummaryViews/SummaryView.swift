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
            FirstView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            SecondView(rowDetailsViewModel: rowDetailsViewModel)
            Divider()
                .background(Color(UIColor.systemGray2))
            VStack(alignment: .leading, spacing: 5) {
                Text("Heart Rate Summary")
                    .bold()
                    .foregroundColor(Color("Main"))
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
                .frame(width: 50, height: 50, alignment: .center)
            VStack(alignment: .leading) {
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

struct FirstView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var duration: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Duration")
                .bold()
                .foregroundColor(Color("Main"))
            Text("\(rowDetailsViewModel.detailsModel.getDuration().0)")
                .workoutTitleStyle()
            + Text(" hr ")
                .workoutSubheadlineStyle()
            + Text("\(rowDetailsViewModel.detailsModel.getDuration().1)")
                .workoutTitleStyle()
            + Text(" min")
                .workoutSubheadlineStyle()
            + Text(" \(rowDetailsViewModel.detailsModel.getDuration().2)")
                .workoutTitleStyle()
            + Text(" sec")
                .workoutSubheadlineStyle()
        }
    }
    
    var energyBurned: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Enery Burned")
                .bold()
                .foregroundColor(Color("Main"))
            Text(rowDetailsViewModel.detailsModel.energyBurned)
                .workoutTitleStyle()
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

struct SecondView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Distance")
                    .bold()
                    .foregroundColor(Color("Main"))
                Text(rowDetailsViewModel.detailsModel.distance)
                    .workoutTitleStyle()
                + Text(" BPM")
                    .workoutSubheadlineStyle()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("Steps")
                    .bold()
                    .foregroundColor(Color("Main"))
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
                .bold()
                .foregroundColor(Color("Main"))
            Text("\(rowDetailsViewModel.detailsModel.cadence)")
                .workoutTitleStyle()
            + Text(" km")
                .workoutSubheadlineStyle()
        }
    }
    
    var range: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text("Heart rate range")
                .bold()
                .foregroundColor(Color("Main"))
            Text("\(rowDetailsViewModel.detailsModel.lowBPM)")
                .workoutTitleStyle()
            + Text(" -- ")
                .workoutSubheadlineStyle()
            + Text("\(rowDetailsViewModel.detailsModel.highBPM)")
                .workoutTitleStyle()
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
                Text("Feedback")
                    .bold()
                    .foregroundColor(Color("Main"))
                Text("\(rowDetailsViewModel.detailsModel.feedbackStyle)")
                    .workoutTitleStyle()
            }
            Spacer()
        }
    }
}
