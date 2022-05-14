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
    @StateObject var metroViewModel = PlayerViewModel()
    
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
                                    metroViewModel.showPickerView.toggle()
                                }
                            } label: {
                                Label("Notification", systemImage: "applewatch.radiowaves.left.and.right")
                                        .frame(width: 190, height: 60)
                                        .background(Color.white)
                                        .foregroundColor(Color.black)
                                        .cornerRadius(25)
                            }
                            
                            Button {
                                withAnimation {
                                    metroViewModel.showPickerView.toggle()
                                }                            } label: {
                                Label("Sound", systemImage: "metronome.fill")
                                        .frame(width: 190, height: 60)
                                        .background(Color.white)
                                        .foregroundColor(Color.black)
                                        .cornerRadius(25)

                            }

//                            NavigationLink(destination: NewWorkOutView()) {
//                                buttonView("Notification feedback")
//                            }
//                            NavigationLink(destination: NewWorkOutView()) {
//                                buttonView("Sound feedback")
//                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 500)
                        .cornerRadius(25.0)
                    }
                    .navigationTitle("Sound of Speed")
                    .navigationBarTitleTextColor(.white)
                    .navigationBarTitleDisplayMode(.large)
                }
                .tabItem {
                    VStack {
                        Image(systemName: "badge.plus.radiowaves.right")
                            .renderingMode(.template)
                        Text("Add workout")
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
            NowPlayingBar(content: ListenNowView(showPlayer: $metroViewModel.showPlayer))
                .tabItem {}
                .offset(y: -50)
            HalfASheet(isPresented: $metroViewModel.showGif) {
                GIFImage(name: "appleWatchAnimation")
                    .frame(height: 250)
            }
            .backgroundColor(.white)
            .closeButtonColor(.white)
            .height(.proportional(0.4))
        }

        if metroViewModel.showPickerView {
            PickerView()
                .transition(.scale)
        }
    }
        .preferredColorScheme(.dark)
        .environmentObject(metroViewModel)
        .ignoresSafeArea(.keyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
