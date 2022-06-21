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

    func adjustOrder() { }
    func rename() { }
    func delay() { }
    func cancelOrder() { }
    
    var body: some View {
        List {
            VStack {
                DashboardRowView(workouts: dashboardViewModel.runningWorkouts, type: .running)
                    .padding(.bottom)
                DashboardRowView(workouts: dashboardViewModel.walkingWorkouts, type: .walking)
//                DashboardRowView(workouts: dashboardViewModel.cyclingWorkouts, type: .cycling)
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.black)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
//        .padding()
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
                Button("Adjust Order", action: adjustOrder)
                Menu("Advanced") {
                    Button("Rename", action: rename)
                    Button("Delay", action: delay)
                }
                Button("Cancel", action: cancelOrder)
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
