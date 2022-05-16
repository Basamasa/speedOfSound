//
//  RowDetailsView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 06.05.22.
//

import SwiftUI
import HealthKit

struct DashboardDetailsView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                SummaryView(rowDetailsViewModel: rowDetailsViewModel)
                HeartRateRangeView(rowDetailsViewModel: rowDetailsViewModel)
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.black)
            }
        }
        .onAppear() {
            rowDetailsViewModel.getHeartRates()
            rowDetailsViewModel.getSteps()
        }
    }
}
