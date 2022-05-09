//
//  RowDetailsView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 06.05.22.
//

import SwiftUI
//import SwiftUICharts
import SwiftUICharts
import HealthKit

struct RowDetailsView: View {
    @StateObject var rowDetailsViewModel: RowDetailsViewModel
    
    var body: some View {
        ScrollView {
            SummaryView(detailsModel: rowDetailsViewModel.detailsModel)
            HeartRateRangeView(rowDetailsViewModel: rowDetailsViewModel)
            HeartRateResultsView(rowDetailsViewModel: rowDetailsViewModel)
        }
        .onAppear() {
            rowDetailsViewModel.getHeartRates()
        }
    }
}

struct SummaryTitleWorkouts: View {
    let type: HKWorkoutActivityType
    var detailsModel: WorktoutDetailsModel

    var body: some View {
        HStack(spacing: 3) {
            if type == .running {
                Image("running")
                    .resizable()
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: 50, height: 50, alignment: .center)
                VStack {
                    Text("Workouts")
                    VStack(alignment: .leading, spacing: 5) {
                        Text(detailsModel.startTime.0)
                            .workoutTitleStyle()
                        + Text(detailsModel.startTime.1)
                                .workoutSubheadlineStyle()
                    }
                }
            } else if type == .cycling {
                Image("cycling")
                    .resizable()
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: 50, height: 50, alignment: .center)
                Text("Workouts")
                    .padding()
            } else if type == .walking {
                Image("walking")
                    .resizable()
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: 50, height: 50, alignment: .center)
                Text("Workouts")
                    .padding()
            }
        }
        .font(Font.body.bold())
        .foregroundColor(Color("Main"))
    }
}

struct SummaryView: View {
    var detailsModel: WorktoutDetailsModel

    var body: some View {
        VStack(alignment: .leading) {
            SummaryTitleWorkouts(type: detailsModel.type, detailsModel: detailsModel)
            VStack(alignment: .leading, spacing: 5) {
                Text("\(detailsModel.durationHours)")
                    .workoutTitleStyle()
                + Text(" hr ")
                    .workoutSubheadlineStyle()
                    + Text("\(detailsModel.durationMinutes)")
                    .workoutTitleStyle()
                + Text(" min")
                    .workoutSubheadlineStyle()
            }
            Divider()
                .background(Color(UIColor.systemGray2))
            VStack(alignment: .leading, spacing: 5) {
                Text(detailsModel.energyBurned)
                    .workoutTitleStyle()
                + Text(" kcal")
                        .workoutSubheadlineStyle()
            }
            Divider()
                .background(Color(UIColor.systemGray2))
            VStack(alignment: .leading, spacing: 5) {
                Text(detailsModel.distance)
                    .workoutTitleStyle()
                + Text(" km")
                    .workoutSubheadlineStyle()
            }
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
        .padding()
    }
}

struct HeartRateRangeView: View {
    @StateObject var rowDetailsViewModel: RowDetailsViewModel
    
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
//            .frame(minWidth: geometry.size.width)
        .padding()
    }
}

struct HeartRateResultsView: View {
    @StateObject var rowDetailsViewModel: RowDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Image(systemName: "heart.fill")
                Text("Summary")
            }
            .font(Font.body.bold())
            .foregroundColor(Color("Main"))
            HorizontalBarChartView(dataPoints: rowDetailsViewModel.heartRatePoints)
                .frame(maxWidth: UIScreen.main.bounds.maxX - 50)
                .frame(height: 200)
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
//            .frame(minWidth: geometry.size.width)
        .padding()
    }
}

//struct RowDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        RowDetailsView()
//    }
//}
