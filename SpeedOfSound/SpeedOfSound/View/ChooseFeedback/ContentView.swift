//
//  ContentView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 20.04.22.
//

import SwiftUI
import HalfASheet
import SwiftUIGIF

struct ContentView: View {
    @StateObject var playerViewModel = PlayerViewModel()
    
    func buttonView(_ text: String) -> some View {
        Text(text)
            .bold()
            .frame(width: 190, height: 60, alignment: .center)
            .background(Color.white)
            .foregroundColor(Color.black)
            .cornerRadius(25)
    }
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                TabView {
                    NavigationView {
                        DashboardView()
                    }
                    .tabItem {
                    }
                }
                .accentColor(.white)

                ListenNowView(showPlayer: $playerViewModel.showPlayer)
                
                HalfASheet(isPresented: $playerViewModel.showGif) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "applewatch.side.right")
                                .foregroundColor(.black)
                            Text("Use our")
                                .foregroundColor(.black)
                            + Text(" Apple Watch ")
                                .bold()
                                .foregroundColor(Color("Main"))
                            + Text("app")
                                .foregroundColor(.black)
                        }

                        GIFImage(name: "appleWatchAnimation")
                            .frame(height: 250)
                    }
                }
                .backgroundColor(.white)
                .closeButtonColor(.white)
                .height(.proportional(0.4))
            }

            if playerViewModel.showNotificationPickerView || playerViewModel.showSoundPickerView {
                PickerView()
            }
        }
//        .onChange(of: playerViewModel.heartRate) { newValue in
//            playerViewModel.changeMetronomeBPM(newHearRateBPM: newValue)
//        }
        .onChange(of: playerViewModel.workoutModel) { newValue in
            playerViewModel.myMetronome.setTempo(to: newValue.cadence)
        }
        .preferredColorScheme(.dark)
        .environmentObject(playerViewModel)
        .ignoresSafeArea(.keyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
