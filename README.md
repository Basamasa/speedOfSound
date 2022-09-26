# Sound of speed
A feedback metronome app for heart rate target zone, developed for Apple Watch and iPhone with Swift and SwiftUI. The application is used to study the influence of the metronome sound on keeping the heart rate zone while running with a feedback application.

## Why is it important?
Target heart rate zone is an important method for professional athletes to avoid training too hard and recover faster, as well as many other benefits. The metronome is also a widely used tool for runners to speed up the runner's cadence, so that the runner needs less leg power to run and can use more gravity, trunk and upper body instead. So, for the sports study, it is important to know whether the metronome can help keep the runner's heart rate zone more constant.

## Study Methods
We will monitor the runners' heart rate during the race with Apple Watch. And we will use an watchOS app to give feedback to runners when the runner is outside the target heart rate zone. The mobile app should be able to give metronome feedback in addition to the normal feedback from watchOS app (notification).
We will first test the normal feedback (notification) without metronome to see how the app makes the runner stay in the target heart rate zone, then we will use both the normal feedback (notification) and metronome to see the difference from the first experiment.

<img src="https://user-images.githubusercontent.com/25714024/192391399-f12dc376-61bb-4642-86b5-02b47f8047b5.PNG" width="550">
<img src="https://user-images.githubusercontent.com/25714024/190269830-171c1caf-835a-48e6-ac4c-4f710c8d0737.png" width="550">


</p>


## Apple Watch App
### Choose feedback. 
* Watch A: 
  * Normale feedback (Apple Watch vibration notification) 
* Watch B: 
  * Sound feedback (Apple Watch vibration notification + Metronome sound from apple watch)
* iOS B: 
  * Sound feedback (Apple Watch vibration notification + Metronome sound from iPhone app)
 
For our study we only need Watch A and iOS B.
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/178289609-42414109-97da-4ab8-b812-35d1a03841f0.PNG" width="150">
</p>

### Calculate Target Heart Rate Zone based on age
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/178289727-9efb0ec9-3427-4294-a16f-ce2c8ef411b5.PNG" width="150">
</p>

### Choose Start Cadence(BPM)
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/178289945-de00fd15-81fa-44a2-acb5-c700080fbc47.PNG" width="150">
</p>

### Running Workouts. 
With Metronome(Watch B), without Metronome(Watch A, iOS B)
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176018979-48cfb8a3-0e14-4a1d-af95-fc7c9aee0a80.PNG" width="150">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/178290154-ee7d80b2-7972-4b35-9765-c95ad31c11e8.PNG" width="150">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/178290179-090241d1-155f-47ef-b4fb-8bc8c784df22.PNG" width="150">
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

### Running test and All workouts
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/178298105-c8479cbe-b13e-48cd-8735-a2e7c00b5f84.PNG" width="250">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/178298124-f887ae79-6021-4831-b036-c1c70add65b4.PNG" width="250">
</p>

### Metronome Player 
Play and pause automatically with Apple Watch when start the running
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/176022146-59cf0aed-bbff-481f-8d56-af9b4e59efca.PNG" width="250">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/176022228-511287ec-b74c-4876-b008-2c12b82506cc.PNG" width="250">
</p>

### Workout Details 
Data That Are Collected
<p float="left">
<img src="https://user-images.githubusercontent.com/25714024/178298434-1aedf103-6f86-49f1-853b-fab82de3fd6a.jpeg" width="250">
&nbsp
<img src="https://user-images.githubusercontent.com/25714024/178298447-0c5b14ea-95b0-4afe-bec4-1156ab1925cb.PNG" width="250">
</p>

### Collected Data
- Heart rate ❤️
- Age
- Chosen feedback
- Mean correction time (The time that runner takes to get back to target zone after leaving it)
- Number of feedback given while running
- Number of times that the runner rised their wrist to see the Apple Watch
- Percentage stayed in target heart rate zone
- Average cadence 
- Calories 

## How to build

- Clone the repo and run MetronomeZones.xcodeproj
- Change team and bundle identifier when necessary
- Make sure Apple Watch and iOS have same bundle identifier
