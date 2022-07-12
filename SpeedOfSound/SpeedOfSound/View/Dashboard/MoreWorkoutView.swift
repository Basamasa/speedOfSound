//
//  RunningDetailsView.swift
//  MetronomeZones
//
//  Created by Anzer Arkin on 27.06.22.
//

import SwiftUI
import HealthKit

struct MoreWorkoutView: View {
    var type: HKWorkoutActivityType

    @Binding var details: Bool
    var animation: Namespace.ID
    @StateObject var dashboardViewModel: DashboardViewModel
    
    var workouts: [HKWorkout] {
        if type == .running {
            return dashboardViewModel.runningWorkouts
        } else if type == .walking {
            return dashboardViewModel.walkingWorkouts
        } else if type == .cycling {
            return dashboardViewModel.cyclingWorkouts
        } else {
            return []
        }
    }
    
    var id: String {
        if type == .running {
            return "running"
        } else if type == .walking {
            return "walking"
        } else if type == .cycling {
            return "cycling"
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            MoreWorkoutTitle(type: type, showPopUp: $details)
            
            Divider()
                .background(Color(UIColor.systemGray2))
            ScrollView {
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
        .matchedGeometryEffect(id: id, in: animation)
        .cardStyle()
        .padding()
    }
}

struct MoreWorkoutTitle: View {
    let type: HKWorkoutActivityType
    @Binding var showPopUp: Bool

    @ViewBuilder
    func showView(imageName: String, name: String) -> some View {
         HStack {
            Image(imageName)
                .resizable()
                .foregroundColor(Color(UIColor.systemGray))
                .frame(width: 50, height: 50, alignment: .center)
            Text(name)
                .foregroundColor(Color("Green"))
                .padding()
            Spacer()
             Button {
                 withAnimation {
                     showPopUp = false
                 }
             } label: {
                 Image(systemName: "xmark")
                     .foregroundColor(Color("Main"))
             }
        }
    }
    
    var body: some View {
        HStack(spacing: 3) {
            if type == .running {
                showView(imageName: "running", name: "Running workout")

            } else if type == .walking {
                showView(imageName: "walking", name: "Walking workout")
            }
        }
        .font(Font.body.bold())
        .foregroundColor(Color("Main"))
    }
}

