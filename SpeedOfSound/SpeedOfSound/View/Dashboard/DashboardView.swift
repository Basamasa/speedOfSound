//
//  DashboardView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 30.04.22.
//

import SwiftUI
import HealthKit
import PermissionsSwiftUIHealth

struct DashboardView: View {
    @StateObject var dashboardViewModel = DashboardViewModel()
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                RecentWorkoutsWidgets(workouts: dashboardViewModel.runningWorkouts, type: .running)
                    .padding(.bottom)
                RecentWorkoutsWidgets(workouts: dashboardViewModel.walkingWorkouts, type: .walking)
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .JMAlert(showModal: $dashboardViewModel.isNotReady, for: [.health(categories: .init(readAndWrite: [HKSampleType.quantityType(forIdentifier: .heartRate)!]))], autoCheckAuthorization: false)
        .task {
            await dashboardViewModel.checkPermission()
            await dashboardViewModel.loadWorkoutData() // ??
        }
        .onAppear() {
            dashboardViewModel.checkCurrentAuthorizationSetting()
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleTextColor(.white)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
