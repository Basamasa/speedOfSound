//
//  ContentView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 20.04.22.
//

import SwiftUI
import HalfASheet
import SwiftUIGIF
import Snap

struct ContentView: View {
    @StateObject var metroViewModel = MetronomeViewModel()
    @State var showPlayer: Bool = false
    
    func buttonView(_ text: String) -> some View {
        Text(text)
            .bold()
            .frame(width: 190, height: 60, alignment: .center)
            .background(Color.white)
            .foregroundColor(Color.green)
            .cornerRadius(25)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                NavigationView {
                    ZStack {
                        Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
                        VStack {
                            Text("Let's workout 💪")
                                .font(.title)
                                .bold()
                                .offset(y: -40)
                                .foregroundColor(Color.white)
                            NavigationLink(destination: NewWorkOutView()) {
                                buttonView("Start new workout")
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 500)
                        .background(Color.green)
                        .cornerRadius(25.0)
                        .shadow(color: Color.black.opacity(0.8), radius: 5, x: 0, y: 2)
                    }
                    .navigationTitle("Sound of Speed")
                    .navigationBarTitleTextColor(.green)
                    .navigationBarTitleDisplayMode(.large)
                }
                .tabItem {
                    Image(systemName: "badge.plus.radiowaves.right")
                    Text("Add workout")
                }
                DashboardView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.fill")
                        Text("Dashboard")
                    }
            }
            .accentColor(.green)
            
            NowPlayingBar(content: ListenNowView(showPlayer: $showPlayer))
                .tabItem {}
                .offset(y: -50)
            
            HalfASheet(isPresented: $metroViewModel.isShowingSheet) {
                GIFImage(name: "appleWatchAnimation")
                    .frame(height: 250)
            }
            .backgroundColor(.white)
            .closeButtonColor(.white)
            .height(.proportional(0.4))
        }
        .environmentObject(metroViewModel)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
