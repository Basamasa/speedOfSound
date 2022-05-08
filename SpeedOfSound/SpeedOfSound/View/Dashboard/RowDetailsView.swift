//
//  RowDetailsView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 06.05.22.
//

import SwiftUI
//import SwiftUICharts
import SwiftUICharts

struct RowDetailsView: View {
    @StateObject var rowDetailsViewModel: RowDetailsViewModel
    
    var body: some View {
        ScrollView {
            HeartRateRangeView(rowDetailsViewModel: rowDetailsViewModel)
            HeartRateSummaryView(rowDetailsViewModel: rowDetailsViewModel)
        }
        .onAppear() {
            rowDetailsViewModel.getHeartRates()
        }
    }
}

struct HeartRateRangeView: View {
    @StateObject var rowDetailsViewModel: RowDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Image(systemName: "heart.fill")
                Text("Details")
                Spacer()
                Image(systemName: "chart.xyaxis.line")
            }
            .font(Font.body.bold())
            .foregroundColor(Color("Main"))
            LineChartView(dataPoints: rowDetailsViewModel.heartRatePoints)
                .frame(maxWidth: UIScreen.main.bounds.maxX - 40)
                .frame(height: 200)
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
//            .frame(minWidth: geometry.size.width)
        .padding()
    }
}

struct HeartRateSummaryView: View {
    @StateObject var rowDetailsViewModel: RowDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Image(systemName: "heart.fill")
                Text("Summary")
            }
            .font(Font.body.bold())
            .foregroundColor(Color("Main"))
            HorizontalBarChartView(dataPoints: rowDetailsViewModel.heartRatePoints)
                .frame(maxWidth: UIScreen.main.bounds.maxX - 50)
                .frame(height: 200)
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
//            .frame(minWidth: geometry.size.width)
        .padding()
    }
}

//struct RowDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        RowDetailsView()
//    }
//}
