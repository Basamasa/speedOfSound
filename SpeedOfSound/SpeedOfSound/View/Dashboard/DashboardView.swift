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
        ScrollView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    RecentWorkoutsWidgets(workouts: dashboardViewModel.recentWorkouts)
                }
                .padding()
            }
        }
        .JMAlert(showModal: $dashboardViewModel.isNotReady, for: [.health(categories: .init(readAndWrite: [HKSampleType.quantityType(forIdentifier: .heartRate)!]))], autoCheckAuthorization: false)
        .task {
            await dashboardViewModel.checkPermission()
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