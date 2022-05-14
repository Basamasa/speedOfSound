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
    @EnvironmentObject var soundViewModel: PlayerViewModel
    @Binding var showPlayer: Bool
    @Namespace var namespace

    var body: some View {
        VStack {
            if !showPlayer {
                ZStack {
                    Image(systemName: "chevron.compact.up")
                        .offset(y: -20)
                        .foregroundColor(.white)
                        .font(.title)
                        .matchedGeometryEffect(id: "Chevron", in: namespace)

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
                        .matchedGeometryEffect(id: "BPM", in: namespace)
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
                        .matchedGeometryEffect(id: "PlayButton", in: namespace)
                    }
                }
                .zIndex(1)
                .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.gray), alignment: .top)
                .background(.black)
                .cornerRadius(10, corners: [.topLeft, .topRight])
                .frame(height: showPlayer == true ? 500 : 65)
                .modifier(DraggableModifier(showPlayer: $showPlayer, direction: .top))
                .transition(.backslide1)
                .matchedGeometryEffect(id: "NowPlayer", in: namespace)
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
                        .matchedGeometryEffect(id: "Chevron", in: namespace)
                        .onTapGesture {
                            withAnimation {
                                showPlayer = false
                            }
                        }
                    PlayerView(namespace: namespace)
                        .matchedGeometryEffect(id: "NowPlayer", in: namespace)
                }
                .zIndex(2)
                .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.gray), alignment: .top)
                .background(.black)
                .cornerRadius(10, corners: [.topLeft, .topRight])
                .transition(.backslide2)
                .modifier(DraggableModifier(showPlayer: $showPlayer, direction: .bottom))
            }
        }
        .onChange(of: soundViewModel.sessionWorkout, perform: { newValue in
            soundViewModel.start()
            soundViewModel.stop()
        })
        .onAppear() {
            soundViewModel.soundViewAppear()
        }
    }
}
