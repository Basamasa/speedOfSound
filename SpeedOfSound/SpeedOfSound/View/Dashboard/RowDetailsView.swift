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
            SummaryView(rowDetailsViewModel: rowDetailsViewModel)
            HeartRateRangeView(rowDetailsViewModel: rowDetailsViewModel)
//            HeartRateResultsView(rowDetailsViewModel: rowDetailsViewModel)
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
                    Text(detailsModel.startTime)
                        .workoutSubheadlineStyle()
                }
            }
            .padding()
        }
        .font(Font.body.bold())
    }
}

struct SummaryView: View {
    @StateObject var rowDetailsViewModel: RowDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            SummaryTitleWorkouts(type: rowDetailsViewModel.type, detailsModel: rowDetailsViewModel.detailsModel)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Duration")
                        .foregroundColor(Color("Main"))
                    Text("\(rowDetailsViewModel.durationHours)")
                        .workoutTitleStyle()
                    + Text(" hr ")
                        .workoutSubheadlineStyle()
                        + Text("\(rowDetailsViewModel.durationMinutes)")
                        .workoutTitleStyle()
                    + Text(" min")
                        .workoutSubheadlineStyle()
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Enery Burned")
                        .foregroundColor(Color("Main"))
                    Text(rowDetailsViewModel.energyBurned)
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
                    Text(rowDetailsViewModel.distance)
                        .workoutTitleStyle()
                    + Text(" km")
                        .workoutSubheadlineStyle()
                }
                Spacer()
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Lower heart rate")
//                        .foregroundColor(Color("Main"))
//                    Text(rowDetailsViewModel.getLowPercentage)
//                        .workoutTitleStyle()
//                    + Text(" %")
//                        .workoutSubheadlineStyle()
//                }
            }
            Divider()
                .background(Color(UIColor.systemGray2))
            VStack(alignment: .leading, spacing: 5) {
                Text("Heart Rate Summary")
                    .foregroundColor(Color("Main"))
                HorizontalBarChartView(dataPoints: rowDetailsViewModel.heartRatePercetages)
                    .frame(maxWidth: UIScreen.main.bounds.maxX - 50)
            }
//                .frame(height: 200)
//            HStack {
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Inside heart rate")
//                        .foregroundColor(Color("Main"))
//                    Text(rowDetailsViewModel.getInsidePercentage)
//                        .workoutTitleStyle()
//                    + Text(" %")
//                        .workoutSubheadlineStyle()
//                }
//                Spacer()
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Higher heart rate")
//                        .foregroundColor(Color("Main"))
//                    Text(rowDetailsViewModel.getHighPercentage)
//                        .workoutTitleStyle()
//                    + Text(" %")
//                        .workoutSubheadlineStyle()
//                }
//            }
//            Divider()
//                .background(Color(UIColor.systemGray2))
//            VStack(alignment: .leading, spacing: 5) {
//                Text("\(rowDetailsViewModel.steps[0])")
//                    .workoutTitleStyle()
//                + Text(" km")
//                    .workoutSubheadlineStyle()
//            }
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
            HorizontalBarChartView(dataPoints: rowDetailsViewModel.heartRatePercetages)
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
