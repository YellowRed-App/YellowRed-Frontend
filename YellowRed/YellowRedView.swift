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
    @State private var countdownTimer: Timer? = nil
    
    @State private var hint: Bool = false
    @State private var hintTimer: Timer? = nil
    
    @State private var isPressingYellowButton: Bool = false
    @State private var isPressingRedButton: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 50) {
                    Spacer()
                    
                    Text("YellowRed")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .opacity((isPressingYellowButton || isPressingRedButton) ? 0 : 1)
                    
                    ZStack {
                        Circle()
                            .fill(.yellow)
                            .frame(width: 200, height: 200)
                            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                isPressingYellowButton = pressing
                                if pressing {
                                    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                        if self.countdown > 0 {
                                            self.countdown -= 1
                                            GlobalHapticManager.shared.triggerHapticFeedback(0.25)
                                        } else {
                                            self.countdownTimer?.invalidate()
                                            self.countdownTimer = nil
                                            self.yellowButton.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.isPressingYellowButton = false
                                            }
                                            UIView.setAnimationsEnabled(false)
                                        }
                                    }
                                } else {
                                    self.countdownTimer?.invalidate()
                                    self.countdownTimer = nil
                                    self.countdown = 5
                                    if self.countdown > 0 {
                                        self.hint = true
                                        self.hintTimer?.invalidate()
                                        self.hintTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                                            self.hint = false
                                        }
                                    }
                                }
                            }, perform: { })
                            .fullScreenCover(isPresented: $yellowButton) {
                                YellowButtonView(yellowButton: $yellowButton)
                            }
                        
                        if isPressingYellowButton && countdown <= 5 {
                            Text("\(countdown)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .opacity(isPressingRedButton ? 0 : 1)
                    .disabled(isPressingRedButton)
                    
                    ZStack {
                        Circle()
                            .fill(.red)
                            .frame(width: 200, height: 200)
                            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                isPressingRedButton = pressing
                                if pressing {
                                    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                        if self.countdown > 0 {
                                            self.countdown -= 1
                                            GlobalHapticManager.shared.triggerHapticFeedback(0.25)
                                        } else {
                                            self.countdownTimer?.invalidate()
                                            self.countdownTimer = nil
                                            self.redButton.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.isPressingRedButton = false
                                            }
                                            UIView.setAnimationsEnabled(false)
                                        }
                                    }
                                } else {
                                    self.countdownTimer?.invalidate()
                                    self.countdownTimer = nil
                                    self.countdown = 5
                                    if self.countdown > 0 {
                                        self.hint = true
                                        self.hintTimer?.invalidate()
                                        self.hintTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                                            self.hint = false
                                        }
                                    }
                                }
                            }, perform: { })
                            .fullScreenCover(isPresented: $redButton) {
                                RedButtonView(redButton: $redButton)
                            }
                        
                        if isPressingRedButton && countdown <= 5 {
                            Text("\(countdown)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .opacity(isPressingYellowButton ? 0 : 1)
                    .disabled(isPressingYellowButton)
                    
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
                    .opacity((isPressingYellowButton || isPressingRedButton) ? 0 : 1)
                    .disabled(isPressingYellowButton || isPressingRedButton)
                }
                
                if hint {
                    Text("Please hold the button for five seconds to activate!")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .offset(y: 250)
                        .opacity((isPressingYellowButton || isPressingRedButton) ? 0 : 1)
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: GlobalHapticManager.shared.startHapticEngine)
        }
    }
    
}

struct YellowButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var yellowButton: Bool
    @State private var flash: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .yellow]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                Spacer()
                
                Text("Yellow Button Activated!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(flash ? .white : .clear)
                    .opacity(flash ? 1 : 0)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    self.yellowButton = false
                    deactivateYellowButton()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Deactivate Yellow Button")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(25)
                        .frame(maxWidth: .infinity)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 50)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            GlobalHapticManager.shared.startHapticEngine()
            activateYellowButton()
        }
    }
    
    private func activateYellowButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            GlobalHapticManager.shared.triggerHapticFeedback(5)
        }
        startFlashing()
        // TODO: activate yellow button
    }
    
    private func deactivateYellowButton() {
        // TODO: deactivate yellow button
    }
    
    private func startFlashing() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            withAnimation {
                self.flash.toggle()
            }
        }
    }
}

struct RedButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var redButton: Bool
    @State private var flash: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.red, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                Spacer()
                
                Text("Red Button Activated!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(flash ? .white : .clear)
                    .opacity(flash ? 1 : 0)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    self.redButton = false
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Deactivate Red Button")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(25)
                        .frame(maxWidth: .infinity)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(.yellow)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 50)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            GlobalHapticManager.shared.startHapticEngine()
            activateRedButton()
        }
    }
    
    private func activateRedButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            GlobalHapticManager.shared.triggerHapticFeedback(5)
        }
        startFlashing()
        // TODO: activate red button
    }
    
    private func deactivateRedButton() {
        // TODO: deactivate red button
    }
    
    private func startFlashing() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            withAnimation {
                self.flash.toggle()
            }
        }
    }
}

struct YellowRedView_Previews: PreviewProvider {
    @State static var yellowButton = false
    @State static var redButton = false
    static var previews: some View {
        YellowRedView()
            .environmentObject(GlobalHapticManager.shared)
        YellowButtonView(yellowButton: $yellowButton)
            .environmentObject(GlobalHapticManager.shared)
        RedButtonView(redButton: $redButton)
            .environmentObject(GlobalHapticManager.shared)
    }
}

class GlobalHapticManager: ObservableObject {
    static let shared = GlobalHapticManager()
    @Published var engine: CHHapticEngine?
    
    private init() {
        startHapticEngine()
    }
    
    deinit {
        stopHapticEngine()
    }
    
    public func startHapticEngine() {
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Failed to start haptic engine: \(error.localizedDescription)")
        }
    }
    
    public func stopHapticEngine() {
        engine?.stop(completionHandler: nil)
        engine = nil
    }
    
    public func triggerHapticFeedback(_ duration: Double) {
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
