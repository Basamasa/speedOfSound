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
                        ZStack {
                            Color.black.edgesIgnoringSafeArea(.all)
                            VStack {
                                Text("Choose a feedback")
                                    .font(.title)
                                    .bold()
                                    .offset(y: -40)
                                    .foregroundColor(Color.white)
                                Button {
                                    withAnimation {
                                        playerViewModel.showNotificationPickerView = true
                                    }
                                } label: {
                                    Label("Notification feedback", systemImage: "applewatch.radiowaves.left.and.right")
                                            .frame(width: 230, height: 60)
                                            .background(.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(25)
                                }
                                
                                Button {
                                    withAnimation {
                                        playerViewModel.showSoundPickerView = true
                                    }
                                } label: {
                                    Label("Sound feedback", systemImage: "metronome.fill")
                                            .frame(width: 230, height: 60)
                                            .background(.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(25)

                                }
                            }
                        }
                        .navigationTitle("Sound of Speed")
                        .navigationBarTitleTextColor(.white)
                        .navigationBarTitleDisplayMode(.large)
                    }
                    .tabItem {
                        VStack {
                            Image(systemName: "badge.plus.radiowaves.right")
                                .renderingMode(.template)
                            Text("Feedback")
                        }

                    }
                    .foregroundColor(.white)

                    NavigationView {
                        ZStack {
                            Color.black.edgesIgnoringSafeArea(.all)
                            DashboardView()
                        }
                    }
                    .tabItem {
                        VStack {
                            Image(systemName: "list.bullet.rectangle.fill")
                                .renderingMode(.template)
                            Text("Dashboard")
                        }
                    }
                }
                .accentColor(.white)
                NowPlayingBar(content: ListenNowView(showPlayer: $playerViewModel.showPlayer))
                    .tabItem {}
                    .offset(y: -50)
                HalfASheet(isPresented: $playerViewModel.showGif) {
                    GIFImage(name: "appleWatchAnimation")
                        .frame(height: 250)
                }
                .backgroundColor(.white)
                .closeButtonColor(.white)
                .height(.proportional(0.4))
            }

            if playerViewModel.showNotificationPickerView || playerViewModel.showSoundPickerView {
                PickerView()
            }
        }
        .onChange(of: playerViewModel.count) { newValue in
            playerViewModel.changeMetronomeBPM(newHearRateBPM: newValue)
        }
        .onChange(of: playerViewModel.workoutModel) { newValue in
            print(newValue)
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
