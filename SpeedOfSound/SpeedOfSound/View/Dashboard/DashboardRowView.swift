//
//  RecentWorkoutsWidgets.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 03.05.22.
//

import SwiftUI
import HealthKit

struct Constants {
    static let widgetMediumHeight: CGFloat = 169
    static let widgetLargeHeight: CGFloat = 376
}

struct DashboardRowView: View {
    let workouts: [HKWorkout]
    let type: HKWorkoutActivityType

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TitleWorkouts(type: type)
            
            Text("You did \(workouts.count) workouts in the last 7 days.")
                .font(Font.body.bold())
                .foregroundColor(Color.white)
            Divider()
                .background(Color(UIColor.systemGray2))
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 20) {
                    ForEach(workouts.batched(into: 3), id: \.self) { items in
                        ThreeRowWorkouts(workouts: items)
                    }
                }
            }
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
    }
}

struct TitleWorkouts: View {
    let type: HKWorkoutActivityType
    var body: some View {
        HStack(spacing: 3) {
            if type == .running {
                Image("running")
                    .resizable()
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: 50, height: 50, alignment: .center)
                Text("Run")
                    .foregroundColor(Color("Green"))
                    .padding()
            } else if type == .walking {
                Image("walking")
                    .resizable()
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: 50, height: 50, alignment: .center)
                Text("Walk")
                    .foregroundColor(Color("Green"))
                    .padding()
            }
        }
        .font(Font.body.bold())
        .foregroundColor(Color("Main"))
    }
}

struct ThreeRowWorkouts: View {
    let workouts: [HKWorkout]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(Array(workouts.enumerated()), id: \.offset) { (offset, element) in
                NavigationLink {
                    ZStack {
                        Color.black.edgesIgnoringSafeArea(.all)
                        DashboardDetailsView(rowDetailsViewModel: DashboardDetailsViewModel(workout: element))
                    }
                } label: {
                    WorkoutRowView(workout: WorktoutDetailsModel(workout: element))
                }
            }
            Spacer()
        }
    }
}

struct WorkoutRowView: View {
    let workout: WorktoutDetailsModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing: -3)  {
                Text(workout.indoorWorktoutMeta)
                    .font(.caption).bold().foregroundColor(Color(UIColor.systemGray)) +
                Text(workout.activityName)
                    .font(.caption).bold().foregroundColor(Color(UIColor.systemGray))
                + Text(workout.nameMeta)
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(workout.getDuration().0)")
                            .workoutTitleStyle()
                        + Text(" hr ")
                            .workoutSubheadlineStyle()
                            + Text("\(workout.getDuration().1)")
                            .workoutTitleStyle()
                        + Text(" min")
                            .workoutSubheadlineStyle()
                            + Text(" \(workout.getDuration().2)")
                            .workoutTitleStyle()
                        + Text(" sec")
                            .workoutSubheadlineStyle()
                    }

                    VStack {
                        Text(workout.date)
                            .workoutDateStyle()
                    }
                    Divider()
                        .background(Color(UIColor.systemGray2))
                }
                .frame(maxHeight: 40)
            }
        }
        .foregroundColor(Color.white)
    }
}
