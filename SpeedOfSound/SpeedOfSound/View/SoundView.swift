//
//  MetroView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import SwiftUI
import AVFoundation
import UIKit

var player: AVAudioPlayer!

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
                    Rectangle()
                        .foregroundColor(Color.green)
                        .frame(width: UIScreen.main.bounds.size.width, height: 65)
                        .background(Blur())
                        .cornerRadius(10, corners: [.topLeft, .topRight])
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
                .matchedGeometryEffect(id: "NowPlayer", in: nspace)
                .modifier(DraggableModifier(direction: .top, showPlayer: $showPlayer))
                .transition(.backslide1)
                .onTapGesture {
                    showPlayer = true
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
                .matchedGeometryEffect(id: "NowPlayer", in: nspace)
                .transition(.backslide2)
                .modifier(DraggableModifier(direction: .bottom, showPlayer: $showPlayer))
                .onTapGesture {
                    showPlayer = false
                }
            }
        }
    }
}

struct SoundView: View {
    
    @EnvironmentObject var soundViewModel: MetronomeViewModel
    @StateObject var model = HeartRateViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Text("❤️ \(model.count)")
                    .font(.largeTitle)
                HStack {
                    Image(systemName: "music.note")
                    Picker("Effect", selection: $soundViewModel.effectIndex) {
                        ForEach(0 ..< soundViewModel.effect.count, id:\.self) { index in
                                Text(soundViewModel.effect[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: soundViewModel.effectIndex) { _ in
                        soundViewModel.runRestart()
                    }
                }
                HStack {
                    HStack {
                        Button(action: {
                            soundViewModel.clickOnMinusButton()
                        }, label: {
                            Circle()
                                .fill(soundViewModel.mode == .stopped ? Colors.grayGradient : Colors.colorGradient)
                                .overlay(
                                    Image(systemName: "minus.circle")
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .foregroundColor(Color("ButtonAccent"))
                                        .font(Font.title.weight(.light)))
                        })
                        
                        Button(action: {
                            soundViewModel.clickOnPlusButton()
                        }, label: {
                            Circle()
                                .fill(soundViewModel.mode == .stopped ? Colors.grayGradient : Colors.colorGradient)
                                .overlay(
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .foregroundColor(Color("ButtonAccent"))
                                        .font(Font.title.weight(.light)))
                        })
                    }
                    .onChange(of: soundViewModel.BPM) { _ in
                        soundViewModel.bpmChange()
                        soundViewModel.runRestart()
                    }
                    Button(action: {
                        soundViewModel.clickOnHeart()
                    }, label: {
                        VStack {
                            Label(soundViewModel.speedString, systemImage: "metronome")
                                .font(.footnote)
                            Text("\(Int(soundViewModel.BPM))")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("BPM")
                                .font(.footnote)
                        }
                        .foregroundColor(Color("ButtonAccent"))
                    })
                    Button(action: {
                        soundViewModel.tapOnStartButton()
                    }, label: {
                        Image(systemName: soundViewModel.mode == .stopped ? "play.fill" : "pause.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("ButtonAccent"))
                            .font(.largeTitle)
                            
                    })
                }
            }
            .padding()
        }
        .frame(height: 250)
        .background(soundViewModel.mode == .stopped ? Colors.grayGradient : Colors.colorGradient)
        .cornerRadius(25.0)
        .shadow(color: Color.black.opacity(0.8), radius: 5, x: 0, y: 2)
        .padding()
        .onAppear() {
            soundViewModel.soundViewAppear()
        }
    }
}

enum isMetroRunning {
    case running
    case stopped
}

