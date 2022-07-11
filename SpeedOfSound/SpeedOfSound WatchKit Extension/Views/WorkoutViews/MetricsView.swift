//
//  MetricsView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 25.04.22.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack(alignment: .leading) {
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                    .foregroundStyle(.yellow)
//                Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
//                        .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                if workoutManager.workoutModel.feedback == .appleWatchSound {
                    VStack(alignment: .leading) {
                        Text(workoutManager.BPM.formatted(.number.precision(.fractionLength(0))) + " BPM")
                            .digitalCrownRotation($workoutManager.BPM)
                        HStack {
                            Button {
                                workoutManager.clickOnMinusButton()
                            } label: {
                                Image(systemName: "minus")
                            }
                            .tint(.green)
                            .font(.title2)
                            .buttonStyle(PlainButtonStyle())
                            .padding([.leading, .trailing])
                            Button {
                                workoutManager.clickOnPlusButton()
                            } label: {
                                Image(systemName: "plus")
                            }
                            .tint(.green)
                            .font(.title2)
                            .buttonStyle(PlainButtonStyle())
                            .padding([.leading, .trailing])
                        }
                    }
                }
//                Text(Measurement(value: workoutManager.distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))
            }
            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                workoutManager.workoutModel.numberOfGotLooked += 1
            }
        }
        .onReceive(workoutManager.heartRateTimer) { time in
            workoutManager.checkHeartRateWithFeedback()
        }
    }
}

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.bold)
            .onChange(of: showSubseconds) {
                timeFormatter.showSubseconds = $0
            }
    }
}

class ElapsedTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = true

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }

        if showSubseconds {
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
        }

        return formattedString
    }
}

struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date

    init(from startDate: Date) {
        self.startDate = startDate
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
