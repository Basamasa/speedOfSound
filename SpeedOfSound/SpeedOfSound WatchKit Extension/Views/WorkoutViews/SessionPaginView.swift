//
//  SessionPaginView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 25.04.22.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, metrics, nowPlaying, map
    }

    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
//            MapView().tag(Tab.map)
//            NowPlayingView().tag(Tab.nowPlaying)
        }
        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying || selection == .map)
        .onChange(of: workoutManager.running) { _ in
            displayMetricsView()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { _ in
            displayMetricsView()
        }
        .sheet(isPresented: $workoutManager.showTooHighFeedback, content: {
            NotificationView(message: "Quick")
        })
        .sheet(isPresented: $workoutManager.showTooLowFeedback, content: {
            NotificationView(message: "Slow")
        })
    }

    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
}
