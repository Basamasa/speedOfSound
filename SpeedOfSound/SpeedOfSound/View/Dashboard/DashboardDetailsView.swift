//
//  RowDetailsView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 06.05.22.
//

import SwiftUI
import SwiftUICharts
import HealthKit

struct DashboardDetailsView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var body: some View {
        ScrollView {
            SummaryView(rowDetailsViewModel: rowDetailsViewModel)
            HeartRateRangeView(rowDetailsViewModel: rowDetailsViewModel)
            Rectangle()
                .frame(height: 50)
                .foregroundColor(.black)
        }
        .onAppear() {
            rowDetailsViewModel.getHeartRates()
            rowDetailsViewModel.getSteps()
        }
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

struct SummaryView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            SummaryTitleWorkouts(type: rowDetailsViewModel.detailsModel.type, detailsModel: rowDetailsViewModel.detailsModel)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Duration")
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
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Enery Burned")
                        .foregroundColor(Color("Main"))
                    Text(rowDetailsViewModel.detailsModel.energyBurned)
                        .workoutTitleStyle()
                    + Text(" kcal")
                            .workoutSubheadlineStyle()
                }
            }
            Divider()
                .background(Color(UIColor.systemGray2))
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Distance")
                        .foregroundColor(Color("Main"))
                    Text(rowDetailsViewModel.detailsModel.distance)
                        .workoutTitleStyle()
                    + Text(" km")
                        .workoutSubheadlineStyle()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Steps")
                        .foregroundColor(Color("Main"))
                    Text("\(rowDetailsViewModel.steps)")
                        .workoutTitleStyle()
                    + Text(" steps")
                        .workoutSubheadlineStyle()
                }
            }
            Divider()
                .background(Color(UIColor.systemGray2))
            VStack(alignment: .leading, spacing: 5) {
                Text("Heart Rate Summary")
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

struct HeartRateRangeView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Image(systemName: "chart.xyaxis.line")
                Text("Details")
            }
            .font(Font.body.bold())
            .foregroundColor(Color("Main"))
            LineChartView(dataPoints: rowDetailsViewModel.heartRatePoints)
                .frame(maxWidth: UIScreen.main.bounds.maxX - 40)
                .frame(height: 200)
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
        .padding()
    }
}
