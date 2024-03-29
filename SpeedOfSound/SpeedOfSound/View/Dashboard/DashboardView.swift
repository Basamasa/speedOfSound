//
//  DashboardView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 30.04.22.
//

import SwiftUI
import HealthKit
import PermissionsSwiftUIHealth
import SwiftUICharts

struct DashboardView: View {
    @StateObject var dashboardViewModel = DashboardViewModel()
    @State private var heartRateMode = true
    @State var showAllRunning = false
    @State var showAllWalking = false

    @Namespace var animation


    var body: some View {
        ZStack {
            List {
                VStack {
                    DashboardRowView(workouts: dashboardViewModel.runningWorkouts, type: .running, animation: animation)

                    DashboardRowView(workouts: dashboardViewModel.walkingWorkouts, type: .walking, animation: animation)

                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(.black)
                }
            }
            .listStyle(PlainListStyle())
        }
        .JMAlert(showModal: $dashboardViewModel.isNotReady, for: [.health(categories: .init(readAndWrite: dashboardViewModel.getPermission))])
        .task {
            await dashboardViewModel.checkPermission()
            await dashboardViewModel.loadWorkoutData() // ??
        }
        .refreshable {
            await dashboardViewModel.loadWorkoutData()
        }
        .onAppear() {
            dashboardViewModel.checkCurrentAuthorizationSetting()
        }
        .navigationTitle("Sound of Speed")
        .navigationBarTitleTextColor(.white)
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            Menu("Options") {
                Toggle("Heart rate mode ❤️", isOn: $heartRateMode)
                Button("Adjust Order", action: {})
                Menu("Advanced") {
                    Button("Rename", action: {})
                    Button("Delay", action: {})
                }
                Button("Cancel", action: {})
            }
            .font(.title3)
            
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
