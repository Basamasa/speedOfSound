//
//  ListenNowView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 02.05.22.
//

import SwiftUI
import AVFoundation

struct NowPlayingBar<Content: View>: View {
    var content: Content
    
    @ViewBuilder var body: some View {
        ZStack(alignment: .bottom) {
            content
        }
    }
}

struct ListenNowView: View {
    @State private var showMediaPlayer = false
    @State private var offset = CGSize.zero

    @EnvironmentObject var soundViewModel: MetronomeViewModel
    @Binding var showPlayer: Bool
    @Namespace var nspace
    
    var body: some View {
        VStack {
            if !showPlayer {
                ZStack {
                    Image(systemName: "chevron.compact.up")
                        .offset(y: -20)
                        .foregroundColor(.white)
                        .font(.title)
                    HStack {
                        HStack {
                            Text("\(Int(soundViewModel.BPM))")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("BPM")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        .foregroundColor(Color("ButtonAccent"))
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            soundViewModel.tapOnStartButton()
                        }, label: {
                            Image(systemName: soundViewModel.mode == .stopped ? "play.fill" : "pause.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        })
                        .padding()
                    }
                }
                .zIndex(1)
                .background(Color.green)
                .cornerRadius(10, corners: [.topLeft, .topRight])
                .frame(height: showPlayer == true ? 500 : 65)
//                .matchedGeometryEffect(id: "NowPlayer", in: nspace)
                .modifier(DraggableModifier(direction: .top, showPlayer: $showPlayer))
                .transition(.backslide1)
                .onTapGesture {
                    withAnimation {
                        showPlayer = true
                    }
                }
            } else {
                VStack {
                    Image(systemName: "chevron.compact.down")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                    SoundView()
                }
                .zIndex(2)
                .background(Color.green)
                .cornerRadius(10, corners: [.topLeft, .topRight])
//                .matchedGeometryEffect(id: "NowPlayer", in: nspace)
                .transition(.backslide2)
                .modifier(DraggableModifier(direction: .bottom, showPlayer: $showPlayer))
                .onTapGesture {
                    withAnimation {
                        showPlayer = false
                    }
                }
            }
        }
        .onChange(of: soundViewModel.sessionWorkout, perform: { newValue in
            soundViewModel.start()
            soundViewModel.stop()
        })
    }
}
