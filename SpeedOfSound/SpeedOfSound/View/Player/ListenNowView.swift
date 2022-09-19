//
//  ListenNowView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 02.05.22.
//

import SwiftUI
import AVFoundation

struct ListenNowView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Binding var showPlayer: Bool
    @Namespace var namespace
    @State var selectedDetent: PresentationDetent = .fraction(0.1)

    var smallPlayer: some View {
        ZStack {
            HStack {
                HStack {
                    Text("\(Int(playerViewModel.BPM))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(playerViewModel.mode == .running ? Color("Green") : .white)

                    Text("BPM")
                        .font(.footnote)
                        .foregroundColor(playerViewModel.mode == .running ? Color("Green") : .white)
                }
                .foregroundColor(Color("ButtonAccent"))
                .padding()
                
                Spacer()
                
                Button(action: {
                    playerViewModel.tapOnStartButton()
                }, label: {
                    Image(systemName: playerViewModel.mode == .stopped ? "play.fill" : "pause.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(playerViewModel.mode == .running ? Color("Green") : .white)
                        .font(.largeTitle)
                })
                .padding()
            }
        }
        .background(.black)
        .cornerRadius(10, corners: [.topLeft, .topRight])
        .frame(height: showPlayer == true ? 500 : 65)
        .onTapGesture {
            withAnimation {
                showPlayer = true
            }
        }
    }
    
    var bigPlayer: some View {
        VStack {
            PlayerView(namespace: namespace)
        }
        .background(.black)
        .cornerRadius(10, corners: [.topLeft, .topRight])
    }
    
    var body: some View {
        VStack {
        }
        .sheet(isPresented: $showPlayer) {
            VStack {
                if selectedDetent == .fraction(0.1) {
                    smallPlayer
                } else {
                    bigPlayer
                }
            }
            .presentationDetents(undimmed: [.fraction(0.1), .medium, .large], selection: $selectedDetent)
            .interactiveDismissDisabled()
        }
        
        .onChange(of: playerViewModel.sessionWorkout, perform: { newValue in
            withAnimation {
                playerViewModel.start()
                playerViewModel.stop()
            }
        })
        .onChange(of: playerViewModel.BPM, perform: { _ in
            playerViewModel.bpmChange()
        })
        .onAppear() {
            playerViewModel.soundViewAppear()
        }
    }
}
