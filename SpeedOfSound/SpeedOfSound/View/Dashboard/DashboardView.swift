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
                    if !showAllRunning {
                        DashboardRowView(workouts: dashboardViewModel.runningWorkouts, type: .running, animation: animation)
                            .matchedGeometryEffect(id: "running", in: animation)
                            .padding(.bottom)
                            .onTapGesture {
                            }
                            .onLongPressGesture {
                                withAnimation {
                                    showAllRunning = true
                                }
                            }
                    }
                    if !showAllWalking {
                        DashboardRowView(workouts: dashboardViewModel.walkingWorkouts, type: .walking, animation: animation)
                            .matchedGeometryEffect(id: "walking", in: animation)
                            .onTapGesture {
                            }
                            .onLongPressGesture {
                                withAnimation {
                                    showAllWalking = true
                                }
                            }
                    }

    //                DashboardRowView(workouts: dashboardViewModel.cyclingWorkouts, type: .cycling)
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(.black)
                }
                .animation(.default, value: showAllRunning)
                .onTapGesture{}
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            
            if showAllRunning {
                MoreWorkoutView(type: .running, details: $showAllRunning, animation: animation, dashboardViewModel: dashboardViewModel)
            }
            
            if showAllWalking {
                MoreWorkoutView(type: .walking, details: $showAllWalking, animation: animation, dashboardViewModel: dashboardViewModel)
            }
        }
        .animation(.default, value: showAllRunning)
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
