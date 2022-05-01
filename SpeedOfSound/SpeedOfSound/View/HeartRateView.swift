//
//  HeartRateView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 24.04.22.
//

import SwiftUI

struct HeartRateView: View {
    @StateObject var model = HeartRateViewModel()
    @EnvironmentObject var metroViewModel: SoundViewModel
    
    var body: some View {
        VStack {
            GeometryReader { g in
                VStack {
                    Text("❤️ \(model.count)")
                        .font(.largeTitle)
                }
            }.padding()
        }
        .frame(height: 500)
        .background((metroViewModel.mode == .stopped ? Colors.grayGradient : Colors.colorGradient))
        .cornerRadius(25.0)
        .shadow(color: Color.black.opacity(0.8), radius: 5, x: 0, y: 2)
        .padding()
    }
}

