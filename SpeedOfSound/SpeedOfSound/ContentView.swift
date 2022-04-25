//
//  ContentView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 20.04.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var metroViewModel = SoundViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                SoundView()
                HeartRateView()
            }
        }
        .environmentObject(metroViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
