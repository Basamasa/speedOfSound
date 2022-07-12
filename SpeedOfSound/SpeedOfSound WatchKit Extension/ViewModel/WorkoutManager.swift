//
//  WorkoutManager.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 25.04.22.
//

import Foundation
import HealthKit
import WatchKit
import UserNotifications
import SwiftUI
import AVFoundation

enum WorkoutState {
    case running
    case paused
    case ended
}

final class WorkoutManager: NSObject, ObservableObject {
    var wcsessionManager = SessionManager()
    var selectedWorkout: WorkoutType?
    var workoutState: WorkoutState = .ended
    
    // Workout state
    @Published var running = false
    
    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    
    // Metronome
    @Published var soundOnAppleWatch = false
    let myMetronome = WatchMetronomeModel(audioFormat: AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!)
    @Published var BPM: Double = 120
    
    // Workout data
    @Published var workoutModel = WorkoutModel()
    var timeList_for_back_to_zone: [CFAbsoluteTime] = []
    var heartRateTimer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()

    // Feedback
    @Published var showTooHighFeedback: Bool = false
    @Published var showTooLowFeedback: Bool = false
    
    // Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0

    @Published var steps: Double = 0
    @Published var averageSteps: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    private func updateBpm() {
        BPM = Double(myMetronome.tempoBPM)
    }
    
    func clickOnMinusButton() {
        myMetronome.incrementTempo(by: -1)
        updateBpm()
    }
    
    func clickOnPlusButton() {
        myMetronome.incrementTempo(by: 1)
        updateBpm()
    }
    
    // MARK: - Workout
    
    private func giveFeedback(message: String) {
        WKInterfaceDevice.current().play(.notification)
//            speechSentence(message)
        workoutModel.numberOfFeedback += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showTooHighFeedback = false
            self.showTooLowFeedback = false
        }
    }
    func checkHeartRateWithFeedback() {
//        guard workoutModel.feedback == .notification else {return}
        if Int(heartRate) > workoutModel.highBPM { // Hihger than the zone
            showTooHighFeedback = true
            giveFeedback(message: "Let's slow down, current heart rate at \(heartRate)")
        } else if Int(heartRate) < workoutModel.lowBPM { // Lower than the zone
            showTooLowFeedback = true
            giveFeedback(message: "Let's speed up, current heart rate at \(heartRate)")
        }
    }
    
    func speechSentence(_ text: String) {
       try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [])
       var utterance: AVSpeechUtterance!
       let synthesizer = AVSpeechSynthesizer()
       utterance = AVSpeechUtterance(string: text)
       utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
       utterance.rate = AVSpeechUtteranceDefaultSpeechRate
       synthesizer.speak(utterance)
   }
    
    func selectedOneWorkout(workoutType: WorkoutType) {
        selectedWorkout = workoutType
        if workoutType == .outdoorWalking || workoutType == .outdoorRunning {
            if workoutType == .outdoorRunning {
                startWorkout(workoutType: HKWorkoutActivityType.running, locationType: .outdoor)
            } else if workoutType == .outdoorWalking {
                startWorkout(workoutType: HKWorkoutActivityType.walking, locationType: .outdoor)
            }
        } else {
            if workoutType == .indoorRunning {
                startWorkout(workoutType: HKWorkoutActivityType.running, locationType: .indoor)
            } else if workoutType == .indoorWalking {
                startWorkout(workoutType: HKWorkoutActivityType.walking, locationType: .indoor)
            }
        }
        
        if workoutModel.feedback == .iosSound {
            wcsessionManager.workSessionBegin()
            wcsessionManager.sendWorkOutModel(workoutModel.getData)
        } else if workoutModel.feedback == .appleWatchSound {
            myMetronome.setTempo(to: workoutModel.cadence)
            updateBpm()
            try? myMetronome.start()
        }
    }
    
    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType, locationType: HKWorkoutSessionLocationType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = locationType

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }

//        let metadata : NSDictionary = [
//            HKMetadataKeyWorkoutBrandName: workoutModel.getData,
//        ]
//
//        builder?.addMetadata(metadata as! [String : String]) { (success, error) in
//        }
        session?.delegate = self
        builder?.delegate = self

        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)

        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
        }
    }

    func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.activitySummaryType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }

    // MARK: - Session State Control

    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }

    func pause() {
        session?.pause()
        wcsessionManager.workSessionEnd()
    }

    func resume() {
        session?.resume()
    }

    func endWorkout() {
        session?.end()
        showingSummaryView = true
        wcsessionManager.workSessionEnd()
        
        if workoutModel.feedback == .appleWatchSound {
            myMetronome.stop()
        }
    }

    // MARK: - Workout Metrics

//    func calculateAverageTimeGoingBackToZone() {
//        guard !timeCountList.isEmpty else { return }
//        let average = Int(timeList_for_back_to_zone.reduce(0, +)) / timeList_for_back_to_zone.count
//        workoutModel.meanTimeNeededGetBackToZone = average
//    }
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.wcsessionManager.bpmchanged(Int(self.heartRate))
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                let stepsUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.steps = statistics.mostRecentQuantity()?.doubleValue(for: stepsUnit) ?? 0
                self.averageSteps = statistics.averageQuantity()?.doubleValue(for: stepsUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }

    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        workout = nil
        session = nil
        steps = 0
        averageSteps = 0
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
        workoutModel.numberOfFeedback = 0
        workoutModel.numberOfGotLooked = 0
        workoutModel.meanTimeNeededGetBackToZone = 0
        timeList_for_back_to_zone = []
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            let metadata : NSDictionary = [
                HKMetadataKeyWorkoutBrandName: workoutModel.getData,
            ]
            
            builder?.addMetadata(metadata as! [String : String]) { (success, error) in
            }
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
            DispatchQueue.main.async {
                self.workoutState = .ended
            }
        } else if toState == .running {
            DispatchQueue.main.async {
                self.workoutState = .running
            }
        } else if toState == .paused {
            DispatchQueue.main.async {
                self.workoutState = .paused
            }
        }
    }
    
//    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
//        switch event.type {
//        case .motionPaused:
//            WKInterfaceDevice.current().play(.stop)
//            pause()
//        case .motionResumed:
//            WKInterfaceDevice.current().play(.start)
//            resume()
//        default: break
//        }
//    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            if workoutState == .running {
                updateForStatistics(statistics)
            }
        }
    }
}

class ParkBenchTimer {
    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?

    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()

        return duration!
    }

    var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}

protocol WatchMetronomeDelegate: AnyObject {
    func metronomeTicking(_ metronome: WatchMetronomeModel, currentTick: Int)
}

class WatchMetronomeModel {
    
    struct Constants {
        static let kBipDurationSeconds = 0.02
        static let kTempoChangeResponsivenessSeconds = 0.25
        static let kDivisions = [2, 4, 8, 16]
    }
    
    struct MeterConfig {
        static let min = 2
        static let `default` = 4
        static let max = 8
    }
    
    struct TempoConfig {
        static let min = 40
        static let `default` = 160
        static let max = 208
    }
    
    public private(set) var meter = 0
    public private(set) var division = 0
    public private(set) var tempoBPM = 0
    public private(set) var beatNumber  = 0
    public private(set) var isPlaying = false
    
    public weak var delegate: WatchMetronomeDelegate?
    
    let engine: AVAudioEngine = AVAudioEngine()
    /// owned by engine
    let player: AVAudioPlayerNode = AVAudioPlayerNode()
    
    let bufferSampleRate: Double
    let audioFormat: AVAudioFormat
    var soundBuffer = [AVAudioPCMBuffer?]()
    
    var timeInterval: TimeInterval = 0
    var divisionIndex = 0
    
    var bufferNumber = 0
    
    var syncQueue = DispatchQueue(label: "Metronome")

    var nextBeatSampleTime: AVAudioFramePosition = 0
    /// controls responsiveness to tempo changes
    var beatsToScheduleAhead  = 0
    var beatsScheduled = 0

    var playerStarted = false

    
    public init(audioFormat:AVAudioFormat) {
        
        self.audioFormat = audioFormat
        self.bufferSampleRate = audioFormat.sampleRate

        initiazeDefaults()
        
        // How many audio frames?
        let bipFrames = UInt32(Constants.kBipDurationSeconds * audioFormat.sampleRate)
        
        // Use two triangle waves which are generate for the metronome bips.
        // Create the PCM buffers.
        soundBuffer.append(AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: bipFrames))
        soundBuffer.append(AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: bipFrames))
        
        // Fill in the number of valid sample frames in the buffers (required).
        soundBuffer[0]?.frameLength = bipFrames
        soundBuffer[1]?.frameLength = bipFrames
        
        // Generate the metronme bips, first buffer will be A440 and the second buffer Middle C.
        let wg1 = TriangleWaveModel(sampleRate: Float(audioFormat.sampleRate), frequency: 261.6)
        let wg2 = TriangleWaveModel(sampleRate: Float(audioFormat.sampleRate))
        
        wg1.render(soundBuffer[0]!)
        wg2.render(soundBuffer[1]!)
        
        engine.attach(player)
        engine.connect(player, to:  engine.outputNode, fromBus: 0, toBus: 0, format: audioFormat)
        
    }
    
    deinit {
        self.stop()
        engine.detach(player)
        soundBuffer[0] = nil
        soundBuffer[1] = nil
    }
    
    public func start() throws {
        
        // Start the engine without playing anything yet.
        try engine.start()
        isPlaying = true
        
        updateTimeInterval()
        nextBeatSampleTime = 0
        beatNumber = 0
        bufferNumber = 0
        
        self.syncQueue.async() {
            self.scheduleBeats()
        }
    }
    
    func initiazeDefaults() {
        tempoBPM = TempoConfig.default
        meter = MeterConfig.default
        timeInterval = 0
        divisionIndex = 1
        beatNumber = 0
        division = Constants.kDivisions[divisionIndex]
        beatsScheduled = 0;
    }

    
    public func stop() {
        isPlaying = false
        
        /* Note that pausing or stopping all AVAudioPlayerNode's connected to an engine does
         NOT pause or stop the engine or the underlying hardware.
         
         The engine must be explicitly paused or stopped for the hardware to stop.
         */
        player.stop()
        player.reset()
        
        /* Stop the audio hardware and the engine and release the resources allocated by the prepare method.
         
         Note that pause will also stop the audio hardware and the flow of audio through the engine, but
         will not deallocate the resources allocated by the prepare method.
         
         It is recommended that the engine be paused or stopped (as applicable) when not in use,
         to minimize power consumption.
         */
        engine.stop()
        
        playerStarted = false
    }
    
    public func incrementTempo(by increment: Int) {
        
        tempoBPM += increment;
        
        tempoBPM = min(max(tempoBPM, TempoConfig.min), TempoConfig.max)
        
        updateTimeInterval()
    }
    
    public func setTempo(to value: Int) {
        
        tempoBPM = min(max(value, TempoConfig.min), TempoConfig.max)
        
        updateTimeInterval()
    }
    
    public func incrementMeter(by increment: Int) {
        meter += increment;
        
        meter = min(max(meter, MeterConfig.min), MeterConfig.max)
        
        beatNumber = 0
    }
    
    public func incrementDivisionIndex(by increment: Int) throws {
        
        let wasRunning = isPlaying
        
        if (wasRunning) {
            stop()
        }
        
        divisionIndex += increment
        
        divisionIndex = min(max(divisionIndex, 0), Constants.kDivisions.count - 1)
        
        division = Constants.kDivisions[divisionIndex];
        
        
        
        if (wasRunning) {
            try start()
        }
    }
    
    public func reset() {
        
        initiazeDefaults()
        updateTimeInterval()
        
        isPlaying = false
        playerStarted = false
    }
    
    
    
    func scheduleBeats() {
        if (!isPlaying) { return }
        
        while (beatsScheduled < beatsToScheduleAhead) {
            // Schedule the beat.
            
            let playerBeatTime = AVAudioTime(sampleTime: nextBeatSampleTime, atRate: bufferSampleRate)
            // This time is relative to the player's start time.
            
            player.scheduleBuffer(soundBuffer[bufferNumber]!, at: playerBeatTime, options: AVAudioPlayerNodeBufferOptions(rawValue: 0), completionHandler: {
                self.syncQueue.async() {
                    self.beatsScheduled -= 1
                    self.bufferNumber ^= 1
                    self.scheduleBeats()
                }
            })
            
            beatsScheduled += 1
            
            if (!playerStarted) {
                // We defer the starting of the player so that the first beat will play precisely
                // at player time 0. Having scheduled the first beat, we need the player to be running
                // in order for nodeTimeForPlayerTime to return a non-nil value.
                player.play()
                playerStarted = true
            }
            
            // Schedule the delegate callback (metronomeTicking:bar:beat:) if necessary.
            
            let callBackMeter = meter
            if let delegate = self.delegate , self.isPlaying && self.meter == callBackMeter {
                let callbackBeat = beatNumber
                
                let nodeBeatTime: AVAudioTime = player.nodeTime(forPlayerTime: playerBeatTime)!
                let output: AVAudioIONode = engine.outputNode
                
//                os_log(" %@, %@, %f", playerBeatTime, nodeBeatTime, output.presentationLatency)
                
                let latencyHostTicks: UInt64 = AVAudioTime.hostTime(forSeconds: output.presentationLatency)
                let dispatchTime = DispatchTime(uptimeNanoseconds: nodeBeatTime.hostTime + latencyHostTicks)
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: dispatchTime) {
                    delegate.metronomeTicking(self, currentTick: callbackBeat)
                }
            }
            beatNumber = (beatNumber + 1) % meter
            
            let samplesPerBeat = AVAudioFramePosition(timeInterval * bufferSampleRate)
            nextBeatSampleTime += samplesPerBeat
        }
    }
    

    func updateTimeInterval() {
        
        timeInterval = (60.0 / Double(tempoBPM)) * (4.0 / Double(Constants.kDivisions[divisionIndex]))
        
        beatsToScheduleAhead = Int(Constants.kTempoChangeResponsivenessSeconds / timeInterval)
        
        beatsToScheduleAhead = max(beatsToScheduleAhead, 1)
    }
    
 
    
}

class TriangleWaveModel: NSObject {
    var mSampleRate: Float = 44100.0
    var mFreqHz: Float = 440.0
    var mAmplitude: Float = 0.25
    var mFrameCount: Float = 0.0
    
    override init() {
        super.init()
    }
    
    convenience init(sampleRate: Float) {
        self.init(sampleRate: sampleRate, frequency: 440.0, amplitude: 0.25)
    }
    
    convenience init(sampleRate: Float, frequency: Float) {
        self.init(sampleRate: sampleRate, frequency: frequency, amplitude: 0.25)
    }
    
    init(sampleRate: Float, frequency: Float, amplitude: Float) {
        super.init()
        
        self.mSampleRate = sampleRate
        self.mFreqHz = frequency
        self.mAmplitude = amplitude
    }
    
    func render(_ buffer: AVAudioPCMBuffer) {
//        print("Buffer: \(buffer.format.description) \(buffer.description)\n")
        
        let nFrames = buffer.frameLength
        let nChannels = buffer.format.channelCount
        let isInterleaved = buffer.format.isInterleaved
        
        let amp = mAmplitude
        
        let phaseStep = mFreqHz / mSampleRate;
        
        if (isInterleaved) {
            var ptr = buffer.floatChannelData?[0]
            
            for frame in 0 ..< nFrames {
                let phase = fmodf(Float(frame) * phaseStep, 1.0)
                let value = (fabsf(2.0 - 4.0 * phase) - 1.0) * amp;
                
                for _ in 0 ..< nChannels {
                    ptr?.pointee = value;
                    ptr = ptr?.successor()
                }
            }
        } else {
            for ch in 0 ..< nChannels {
                var ptr = buffer.floatChannelData?[Int(ch)]
                
                for frame in 0 ..< nFrames {
                    let phase = fmodf(Float(frame) * phaseStep, 1.0)
                    let value = (fabsf(2.0 - 4.0 * phase) - 1.0) * amp;
                    
                    ptr?.pointee = value
                    
                    ptr = ptr?.successor()
                }
            }
        }
        mFrameCount = Float(nFrames);
    }
}
