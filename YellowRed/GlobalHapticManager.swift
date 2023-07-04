//
//  GlobalHapticManager.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import CoreHaptics

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
