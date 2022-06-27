# Sound of speed
An feedback metronome app for target heart rate zone developed on Apple Watch and iPhone using Swift and SwiftUI.
The application is for studying the influence of metronome sound on keeping the heart rate zone when running using a feedback application.

## Why is it important?
Target heart rate zone is an important method for professional athlete to avoid training too hard and recover faster and many other benefits. Metronome is also a widely used tool for runners to quicken runner’s cadence so the runner will require less leg power to run and use more gravity, core and upper body instead. So for sport study, we think it’s important to know if the metronome can help keep the runner’s heart rate zone more steady.

## Study Methods
We will monitor runner’s heart rate while they are running using a smart-watch. And we will use a mobile app to give runners feedback if the runner is out of target heart rate zone. And the mobile app should also have metronome feedback ability additional to normal feedback(Notification).
We will first test using the normal feedback(Notification) without metronome to see the effect of the app for controlling the runner to stay in target hear rate zone, then we will test using both normal feedback(Notification) and metronome to see the difference from the first experiment.

## Apple Watch App
### Choose feedback
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176018208-aaf9456b-0167-400c-9bbc-0bf482cda00b.PNG" width="150">
</p>

### Calculate Target Heart Rate Zone
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176018284-00236c1a-b274-4714-adc3-90a2bf7c3c39.PNG" width="150">
</p>

### Calculate Avearge Cadence(BPM)
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176018367-b0c1c3c9-e4fd-4076-9171-38b136a89c27.PNG" width="150">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176020462-8faa1e12-3bae-4f18-aa38-0b93b9d1d038.PNG" width="150">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176020332-d0184436-f936-42d6-aa45-a3bf898973d0.PNG" width="150">

</p>

### Running Workouts
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176018979-48cfb8a3-0e14-4a1d-af95-fc7c9aee0a80.PNG" width="150">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176018644-57cf246e-390e-4c80-9636-489254f86649.PNG" width="150">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176018700-720f906b-1c2a-4ab7-99ec-4cc49cc0a844.PNG" width="150">
</p>

### Feedback with Sound
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176020183-d7ab197f-6172-4a18-98be-efa68fe69695.PNG" width="150">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176020257-8c1a291e-55ed-481f-8dc0-3a14735d2927.PNG" width="150">
</p>

## iOS App

### Running and Walking Workouts (In HealthKit Database)
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176021384-267a1b72-23c4-4a22-af83-138ad4ab8656.PNG" width="250">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176021437-cd89ce19-84d2-43e6-a5e7-c1654f93d38b.PNG" width="250">
</p>

### Metronome Player (Play and Pause Automatically With Apple Watch When Start Working Out)
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176022146-59cf0aed-bbff-481f-8d56-af9b4e59efca.PNG" width="250">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176022228-511287ec-b74c-4876-b008-2c12b82506cc.PNG" width="250">
</p>

### Workout Details (Data That Are Collected)
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176022303-8af7dca8-44c1-464a-a64f-43dd740402c0.PNG" width="250">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176022318-4247f12f-f762-442d-b110-6deeef9dabd1.PNG" width="250">
</p>

### Collected Data
- Heart rate ❤️
- Age 👨🏻‍💼
- Chosen feedback 🎼
- Mean correction time (The time that runner takes to get back to target zone after leaving it) 🚶🏻
- Resting heart rate 🤍
- Number of feedback given while running #️⃣
- Number of times that the runner rised their wrist to see the Apple Watch #️⃣
- Target heart rate zone 💕
- Average cadence 🚶🏻
- Calories 🍕

## How to build

- Clone the repo and run MetronomeZones.xcodeproj
- Change team and bundle identifier when necessary
- Make sure Apple Watch and iOS have same bundle identifier
