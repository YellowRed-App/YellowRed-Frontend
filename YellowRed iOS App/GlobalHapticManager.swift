//
//  GlobalHapticManager.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import CoreHaptics
import Combine
import UIKit

final class GlobalHapticManager: ObservableObject {
    static let shared = GlobalHapticManager()
    
    @Published var engine: CHHapticEngine?
    private var startEngine: Bool = true
    
    private var player: CHHapticPatternPlayer?

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        setupHapticEngine()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        stopHapticEngine()
    }
    
    private func setupHapticEngine() {
        do {
            self.engine = try CHHapticEngine()
            self.engine?.stoppedHandler = { reason in
                print("Haptic engine stopped: \(reason.rawValue)")
                self.startEngine = true
            }
            self.engine?.resetHandler = {
                print("Haptic engine reset")
                self.startEngine = true
                self.startHapticEngine()
            }
        } catch {
            print("Failed to set up haptic engine: \(error.localizedDescription)")
        }
    }
    
    public func startHapticEngine() {
        guard let engine = engine else { return }
        if startEngine {
            do {
                try engine.start()
                startEngine = false
                print("Haptic engine started")
            } catch {
                print("Failed to start haptic engine: \(error.localizedDescription)")
            }
        }
    }
    
    public func stopHapticEngine() {
        guard let engine = engine else { return }
        engine.stop(completionHandler: { error in
            if let error = error {
                print("Failed to stop haptic engine: \(error.localizedDescription)")
            } else {
                print("Haptic engine stopped")
            }
        })
        startEngine = true
    }
    
    public func triggerHapticFeedback(_ duration: Double) {
        guard let engine = engine else {
            print("Haptic engine is not initialized.")
            return
        }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: duration)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            player = try engine.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic feedback: \(error.localizedDescription)")
        }
    }
    
    public func stopHapticFeedback() {
        do {
            try player?.stop(atTime: 0)
            print("Haptic feedback stopped")
        } catch {
            print("Failed to stop haptic feedback: \(error.localizedDescription)")
        }
    }
    
    @objc private func didEnterBackground() {
        stopHapticEngine()
    }
    
    @objc private func willEnterForeground() {
        startHapticEngine()
    }
}
