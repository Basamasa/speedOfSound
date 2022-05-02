//
//  DashboardView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 30.04.22.
//

import SwiftUI

struct DashboardView: View {
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
                VStack() {
                   Text("Hi")
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleTextColor(.green)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
