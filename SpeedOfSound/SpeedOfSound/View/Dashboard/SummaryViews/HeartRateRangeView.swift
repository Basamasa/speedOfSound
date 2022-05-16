//
//  HeartRateRangeView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI
import SwiftUICharts

struct HeartRateRangeView: View {
    @StateObject var rowDetailsViewModel: DashboardDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Image(systemName: "chart.xyaxis.line")
                Text("Details")
            }
            .font(Font.body.bold())
            .foregroundColor(Color("Main"))
            LineChartView(dataPoints: rowDetailsViewModel.heartRatePoints)
                .frame(maxWidth: UIScreen.main.bounds.maxX - 40)
                .frame(height: 200)
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
        .padding()
    }
}
