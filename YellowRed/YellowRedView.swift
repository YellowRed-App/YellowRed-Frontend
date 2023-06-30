//
//  YellowRedView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI
import CoreHaptics

struct YellowRedView: View {
    @State private var profile: Bool = false
    
    @State private var yellowButton: Bool = false
    @State private var redButton: Bool = false
    
    @State private var countdown: Int = 5
    @State private var timer: Timer? = nil
    
    @State private var hint: Bool = false
    @State private var hintTimer: Timer? = nil
    
    @State private var isPressing: Bool = false
    
    @State private var engine: CHHapticEngine?
    
    @State private var flash: Bool = false
    @State private var flashYellow: Bool = false
    
    var body: some View {
        ZStack {
            if flash {
                Color(flashYellow ? .yellow : .white)
                    .animation(.default)
                    .edgesIgnoringSafeArea(.all)
            } else {
                LinearGradient(
                    gradient: yellowButton ? Gradient(colors: [.yellow, .yellow]) : Gradient(colors: [.blue, .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing: 50) {
                Spacer()
                
                Text("YellowRed")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .opacity((isPressing || yellowButton) ? 0 : 1)
                
                ZStack {
                    Circle()
                        .fill(.yellow)
                        .frame(width: 200, height: 200)
                        .opacity(yellowButton ? 0 : 1)
                        .disabled(yellowButton)
                        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                            if !yellowButton {
                                isPressing = pressing
                                if pressing {
                                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                        if self.countdown > 0 {
                                            self.countdown -= 1
                                            triggerHapticFeedback(0.1)
                                        } else {
                                            self.timer?.invalidate()
                                            self.timer = nil
                                            self.yellowButton.toggle()
                                            self.yellowButtonAction()
                                            triggerHapticFeedback(5)
                                            flashBackground()
                                        }
                                    }
                                } else {
                                    self.timer?.invalidate()
                                    self.timer = nil
                                    self.countdown = 5
                                    if self.countdown > 0 {
                                        self.hint = true
                                        self.hintTimer?.invalidate()
                                        self.hintTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                                            self.hint = false
                                        }
                                    }
                                }
                            }
                        }, perform: { })
                    
                    if !yellowButton && isPressing && countdown <= 5 {
                        Text("\(countdown)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    redButton.toggle()
                    redButtonAction()
                }) {
                    Circle()
                        .fill(.red)
                        .frame(width: 200, height: 200)
                }
                .opacity((isPressing || yellowButton) ? 0 : 1)
                .disabled(isPressing || yellowButton)
                
                Spacer()
                
                Button(action: {
                    profile = true
                }) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }
                .background(
                    NavigationLink(
                        destination: ProfileView(),
                        isActive: $profile,
                        label: { EmptyView() }
                    )
                )
                .opacity((isPressing || yellowButton) ? 0 : 1)
                .disabled(isPressing || yellowButton)
            }
            
            if hint {
                Text("Please hold the yellow button for five seconds to activate!")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                    .offset(y: 250)
                    .opacity((isPressing || yellowButton) ? 0 : 1)
            }
            
            if yellowButton {
                Text("Yellow Button Activated!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(flash ? flashYellow ? .white : .yellow : .white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .animation(.default)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: startHapticEngine)
        .onDisappear(perform: stopHapticEngine)
    }
    
    private func yellowButtonAction() {
        // TODO: yellow button
    }
    
    private func redButtonAction() {
        // TODO: red button
    }
    
    private func flashBackground() {
        flash = true
        var flashCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            flashYellow.toggle()
            flashCount += 1
            
            if flashCount >= 20 {
                flash = false
            }
        }
    }

    private func startHapticEngine() {
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Failed to start haptic engine: \(error.localizedDescription)")
        }
    }
    
    private func stopHapticEngine() {
        engine?.stop(completionHandler: nil)
        engine = nil
    }
    
    private func triggerHapticFeedback(_ duration: Double) {
        guard let engine = engine else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: duration)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic feedback: \(error.localizedDescription)")
        }
    }
}

struct YellowRedView_Previews: PreviewProvider {
    static var previews: some View {
        YellowRedView()
    }
}
