//
//  RowDetailsView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 06.05.22.
//

import SwiftUI
import HealthKit
import SwiftUICharts

struct DashboardDetailsView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                HeartRateRangeView(rowDetailsViewModel: rowDetailsViewModel)
                SummaryView(rowDetailsViewModel: rowDetailsViewModel)
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.black)
            }
        }
        .navigationTitle("Workout details")
        .onAppear() {
            rowDetailsViewModel.getHeartRates()
            rowDetailsViewModel.getSteps()
        }
    }
}
