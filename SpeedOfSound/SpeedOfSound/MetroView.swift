//
//  MetroView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import SwiftUI
import AVFoundation

var player: AVAudioPlayer!

struct MetroView: View {
    
    @ObservedObject var metroViewModel = MetroViewModel()
    
    let colorGradient = LinearGradient(
        gradient: Gradient(colors: [Color.cyan, Color.green]),
                            startPoint: .topLeading, endPoint: .bottomTrailing)
    let grayGradient = LinearGradient(
                            gradient: Gradient(colors: [Color(.systemGray4), Color(.systemGray4)]),
                            startPoint: .topLeading, endPoint: .bottomTrailing)
    let BPMtimer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                VStack {
                    HStack {
                        Spacer()
                        if(metroViewModel.mode == .stopped) {
                            Button(action: {
                                metroViewModel.start(interval: 60/metroViewModel.BPM,
                                                     effect: metroViewModel.effectIndex,
                                                     time: Int(metroViewModel.beatsIndex))
                            }, label: {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("ButtonAccent"))
                                    .font(.largeTitle)
                                    
                            })
                        } else {
                            Button(action: {
                                metroViewModel.stop()
                            }, label: {
                                Image(systemName: "pause.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("ButtonAccent"))
                                    .font(.largeTitle)
                            })
                        }
                        Button(action: {
                            metroViewModel.clickOnHeart()
                        }, label: {
                            VStack {
                                Label("BPM", systemImage: "heart")
                                Text("\(Int(metroViewModel.BPM))")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text(metroViewModel.speedString)
                                    .font(.footnote)
                            }
                            .foregroundColor(Color("ButtonAccent"))
                        })
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                metroViewModel.clickOnMinusButton()
                            }, label: {
                                Circle()
                                    .fill(metroViewModel.mode == .stopped ? grayGradient : colorGradient)
//                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "minus.circle")
                                            .resizable()
                                            .frame(width: 90, height: 90)
                                            .foregroundColor(Color("ButtonAccent"))
                                            .font(Font.title.weight(.light)))
                            })
                            .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                                metroViewModel.longPressMinusTap()
                            })
                            
                            Button(action: {
                                metroViewModel.clickOnPlusButton()
                            }, label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(metroViewModel.mode == .stopped ? grayGradient : colorGradient)
//                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 90, height: 90)
                                            .foregroundColor(Color("ButtonAccent"))
                                            .font(Font.title.weight(.light)))
                            })
                            .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                                metroViewModel.longPressPlusTap()
                            })
                        }
//                        .animation(.easeIn)
                        .onChange(of: metroViewModel.BPM) { _ in
                            metroViewModel.bpmChange()
                            metroViewModel.runRestart()
                        }
                    }
                    
                    HStack {
                        Image(systemName: "music.quarternote.3")
                        Picker("Effect", selection: $metroViewModel.effectIndex) {
                            ForEach(0 ..< metroViewModel.effect.count) { index in
                                    Text(metroViewModel.effect[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: metroViewModel.effectIndex) { _ in
                            metroViewModel.runRestart()
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
        .frame(height: 200)
        .background(metroViewModel.mode == .stopped ? grayGradient : colorGradient)
        .cornerRadius(25.0)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .onReceive(BPMtimer) { _ in metroViewModel.difference1 += 0.001}
        .padding()
    }
}

enum isMetroRunning {
    case running
    case stopped
}

