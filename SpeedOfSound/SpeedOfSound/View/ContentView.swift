//
//  ContentView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 20.04.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var metroViewModel = MetronomeViewModel()
    
    func buttonView(_ text: String) -> some View {
        Text(text)
            .bold()
            .frame(width: 190, height: 60, alignment: .center)
            .background(Color.white)
            .foregroundColor(Color.green)
            .cornerRadius(25)

    }
    
    var body: some View {
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
                .padding()
                .navigationTitle("Sound of Speed")
                .navigationBarTitleTextColor(.green)
                .navigationBarTitleDisplayMode(.large)
                }
            }
            .tabItem {
                Image(systemName: "1.square.fill")
                Text("First")
            }
            DashboardView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Dashboard")
                }
        }
        .font(.headline)
        .environmentObject(metroViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}
