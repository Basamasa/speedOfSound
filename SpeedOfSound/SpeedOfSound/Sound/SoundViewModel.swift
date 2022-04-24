//
//  MetroViewModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import Foundation
import AVFoundation

class SoundViewModel: ObservableObject {
    @Published var mode:isMetroRunning = .stopped
    @Published var effectIndex = 0
    @Published var effect = ["1","2","3","4","5","6","7","8"]
    @Published var beatsIndex: Double = 1
    @Published var fastPlus = false
    @Published var fastMinus = false
    @Published var timer1: Timer?
    @Published var wasRunning = false
    
    @Published var BPM: Double = 120
    @Published var difference1: Float = 0
    @Published var difference2: Float = 0
    @Published var currentNum = 1
    @Published var meas1 = -1
    @Published var meas2 = -1
    @Published var meas3 = -1
    @Published var calc1 = -1
    @Published var speedString = "Allegro"
    
    let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
    
    var timer = Timer()
    
    func start(interval: Double, effect: Int, time: Int) {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { timer in
                self.playSound(effect: effect)
            }
    }
    
    func stop() {
        mode = .stopped
        timer.invalidate()
    }
    
    func clickOnHeart() {
        difference2 = 60000/difference1
        BPM = Double(Int(difference2/1000))
        
        if(currentNum == 1) {
            meas1 = Int(BPM)
            currentNum = 2
        }
        else if(currentNum == 2) {
            meas2 = Int(BPM)
            currentNum = 3
        }
        else if(currentNum == 3) {
            meas3 = Int(BPM)
            currentNum = 1
        }
        
        calc1 = meas1 + meas2 + meas3
        BPM = Double(calc1/3)
        difference1 = 0
    }
    
    func bpmChange() {
        if(BPM <= 15) {
            BPM = 15
        }
        if(BPM >= 500) {
            BPM = 500
        }
        
        if(BPM >= 15) {
            speedString = "Grave"
        }
        if(BPM >= 40) {
            speedString = "Lento"
        }
        if(BPM >= 45) {
            speedString = "Largo"
        }
        if(BPM >= 55) {
            speedString = "Adagio"
        }
        if(BPM >= 65) {
            speedString = "Adagietto"
        }
        if(BPM >= 73) {
            speedString = "Andante"
        }
        if(BPM >= 86) {
            speedString = "Moderato"
        }
        if(BPM >= 98) {
            speedString = "Allegretto"
        }
        if(BPM >= 109) {
            speedString = "Allegro"
        }
        if(BPM >= 132) {
            speedString = "Vivace"
        }
        if(BPM >= 168) {
            speedString = "Presto"
        }
        if(BPM >= 178) {
            speedString = "Prestissimo"
        }
    }
    
    func clickOnMinusButton() {
        if fastMinus {
            fastMinus.toggle()
            timer1?.invalidate()
        } else {
            BPM = BPM - 1
        }
    }
    
    func clickOnPlusButton() {
        if fastPlus {
            fastPlus.toggle()
            timer1?.invalidate()
        } else {
            BPM = BPM + 1
        }
    }
    
    func longPressPlusTap() {
        fastPlus = true
        timer1 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.BPM += 1
        })
    }
    
    func longPressMinusTap() {
        fastMinus = true
        timer1 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.BPM -= 1
        })
    }
    
    func runRestart() {
        if mode == .running {
            wasRunning = true
        }
        else {
            wasRunning = false
        }
        stop()
        if wasRunning == true {
            start(interval: 60/BPM,
                                 effect: effectIndex,
                                 time: Int(beatsIndex))
        }
    }
    
    func playSound(effect: Int) {
        var url = Bundle.main.url(forResource: "Mechanical metronome - High", withExtension: "aif")
        
        switch effect {
        case 0:
            url = Bundle.main.url(forResource: "Mechanical metronome - High", withExtension: "aif")
        case 1:
            url = Bundle.main.url(forResource: "Hi-hat", withExtension: "aif")
        case 2:
            url = Bundle.main.url(forResource: "Cowbell", withExtension: "aif")
        case 3:
            url = Bundle.main.url(forResource: "Bass drum", withExtension: "aif")
        case 4:
            url = Bundle.main.url(forResource: "Jack slap", withExtension: "aif")
        case 5:
            url = Bundle.main.url(forResource: "Mechanical metronome - Low", withExtension: "aif")
        case 6:
            url = Bundle.main.url(forResource: "Rimshot", withExtension: "aif")
        case 7:
            url = Bundle.main.url(forResource: "LAUGH!", withExtension: "aif")
        default:
            url = Bundle.main.url(forResource: "Mechanical metronome - High", withExtension: "aif")
        }
        
        guard url != nil else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch {
            print("\(error)")
        }
    }
}
