//
//  YellowRedView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI
import FirebaseAuth

struct YellowRedView: View {
    @State private var profile: Bool = false
    
    @State private var yellowButton: Bool = false
    @State private var redButton: Bool = false
    @State private var activeButton: ActiveButton = .none
    
    @State private var yellowCountdown: Int = 3
    @State private var redCountdown: Int = 5
    @State private var countdownTimer: Timer? = nil
    
    @State private var yellowHint: Bool = false
    @State private var redHint: Bool = false
    @State private var hintTimer: Timer? = nil
    
    @State private var isPressingYellowButton: Bool = false
    @State private var isPressingRedButton: Bool = false
    
    @State private var navigateToYellowButtonView = UserDefaults.standard.bool(forKey: "YellowButtonActivated")
    @State private var navigateToRedButtonView = UserDefaults.standard.bool(forKey: "RedButtonActivated")
    
    @StateObject private var locationManager = LocationManager()
    
    enum ActiveButton {
        case none
        case yellow
        case red
    }
    
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
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .opacity((isPressingYellowButton || isPressingRedButton) ? 0 : 1)
                    
                    ZStack {
                        Circle()
                            .fill(.yellow)
                            .frame(width: 200, height: 200)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .opacity(activeButton == .red ? 0 : 1)
                            .disabled(activeButton == .red)
                            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                guard activeButton != .red else { return }
                                isPressingYellowButton = pressing
                                if pressing {
                                    startCountdown(button: .yellow)
                                } else {
                                    endCountdown()
                                }
                            }, perform: { })
                            .fullScreenCover(isPresented: $yellowButton) {
                                YellowButtonView(yellowButton: $yellowButton)
                            }
                        
                        if isPressingYellowButton {
                            Text("\(yellowCountdown)")
                                .font(.system(size: 125))
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .scaledToFit()
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .fill(.red)
                            .frame(width: 200, height: 200)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .opacity(activeButton == .yellow ? 0 : 1)
                            .disabled(activeButton == .yellow)
                            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                guard activeButton != .yellow else { return }
                                isPressingRedButton = pressing
                                if pressing {
                                    startCountdown(button: .red)
                                } else {
                                    endCountdown()
                                }
                            }, perform: { })
                            .fullScreenCover(isPresented: $redButton) {
                                RedButtonView(redButton: $redButton)
                            }
                        
                        if isPressingRedButton {
                            Text("\(redCountdown)")
                                .font(.system(size: 125))
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .scaledToFit()
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        profile = true
                    }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.black)
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
                    .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
                
                if yellowHint {
                    Text("Please hold the yellow button for three seconds to activate!")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .offset(y: 250)
                        .opacity((isPressingYellowButton || isPressingRedButton) ? 0 : 1)
                }
                
                if redHint {
                    Text("Please hold the red button for five seconds to activate!")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .offset(y: 250)
                        .opacity((isPressingYellowButton || isPressingRedButton) ? 0 : 1)
                }
            }
        }
        .onAppear {
            locationManager.fetchData() {
                if navigateToYellowButtonView {
                    yellowButton = true
                } else if navigateToRedButtonView {
                    redButton = true
                }
                GlobalHapticManager.shared.startHapticEngine()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func startCountdown(button: ActiveButton) {
        activeButton = button
        
        countdownTimer?.invalidate()
        let updateCountdown: () -> Void = {
            switch activeButton {
            case .yellow:
                if yellowCountdown > 1 {
                    yellowCountdown -= 1
                    GlobalHapticManager.shared.triggerHapticFeedback(0.25)
                } else {
                    yellowButton = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        endCountdown()
                    }
                }
            case .red:
                if redCountdown > 1 {
                    redCountdown -= 1
                    GlobalHapticManager.shared.triggerHapticFeedback(0.25)
                } else {
                    redButton = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        endCountdown()
                    }
                }
            case .none:
                break
            }
        }
        
        if button != .none {
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                updateCountdown()
            }
        }
    }
    
    private func endCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        yellowCountdown = 3
        redCountdown = 5
        if activeButton == .yellow {
            yellowHint = true
            redHint = false
            restartHintTimer(button: .yellow)
        } else if activeButton == .red {
            redHint = true
            yellowHint = false
            restartHintTimer(button: .red)
        } else {
            yellowHint = false
            redHint = false
        }
        activeButton = .none
    }
    
    private func restartHintTimer(button: ActiveButton) {
        hintTimer?.invalidate()
        hintTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            if button == .yellow {
                yellowHint = false
            } else if button == .red {
                redHint = false
            }
        }
    }
}

struct YellowButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var yellowButton: Bool
    
    @State private var flash: Bool = false
    
    @StateObject private var userViewModel = UserViewModel()
    
    @StateObject private var locationManager = LocationManager()
    
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
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button(action: {
                    yellowButton = false
                    deactivateYellowButton()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Deactivate Yellow Button")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(25)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 100)
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: activateYellowButton)
    }
    
    private func activateYellowButton() {
        startFlashing()
        let currentSessionId = UserDefaults.standard.string(forKey: "currentSessionId")
        if currentSessionId == nil {
            GlobalHapticManager.shared.startHapticEngine()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                GlobalHapticManager.shared.triggerHapticFeedback(5)
            }
            if let userUID = Auth.auth().currentUser?.uid {
                fetchAllData(userId: userUID) {
                    locationManager.requestLocationPermission()
                    locationManager.activateButton(userId: userUID, button: .yellow) {
                        print("Yellow Button Activated")
                    }
                }
            }
        }
    }
    
    private func deactivateYellowButton() {
        stopFlashing()
        locationManager.deactivateButton()
    }
    
    private func fetchAllData(userId: String, completion: @escaping () -> Void) {
        self.userViewModel.fetchUserData(userId: userId) { userDataResult in
            switch userDataResult {
            case .success:
                self.userViewModel.fetchEmergencyContacts(userId: userId) { emergencyContactsResult in
                    switch emergencyContactsResult {
                    case .success:
                        self.userViewModel.fetchYellowRedMessages(userId: userId) { yellowRedMessagesResult in
                            switch yellowRedMessagesResult {
                            case .success:
                                completion()
                            case .failure(let error):
                                print("Error fetching yellow message: \(error.localizedDescription)")
                                completion()
                            }
                        }
                    case .failure(let error):
                        print("Error fetching emergency contacts: \(error.localizedDescription)")
                        completion()
                    }
                }
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    private func startFlashing() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            withAnimation {
                self.flash.toggle()
            }
        }
    }
    
    private func stopFlashing() {
        flash = false
    }
}

struct RedButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var redButton: Bool
    
    @State private var flash: Bool = false
    @State private var alert: Bool = false
    
    @StateObject private var userViewModel = UserViewModel()
    
    @StateObject private var locationManager = LocationManager()
    
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
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button(action: {
                    alert = true
                }) {
                    Text("Deactivate Red Button")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(25)
                        .frame(maxWidth: .infinity)
                        .background(.yellow)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 100)
                }
                .alert(isPresented: $alert) {
                    Alert(
                        title: Text("Are you sure you are ok and want to deactivate the red button?"),
                        primaryButton: .destructive(Text("No, I'm not ok")),
                        secondaryButton: .cancel(Text("Yes, I'm ok")) {
                            redButton = false
                            deactivateRedButton()
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: activateRedButton)
    }
    
    private func activateRedButton() {
        startFlashing()
        let currentSessionId = UserDefaults.standard.string(forKey: "currentSessionId")
        if currentSessionId == nil {
            GlobalHapticManager.shared.startHapticEngine()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                GlobalHapticManager.shared.triggerHapticFeedback(5)
            }
            if let userUID = Auth.auth().currentUser?.uid {
                fetchAllData(userId: userUID) {
                    locationManager.requestLocationPermission()
                    locationManager.activateButton(userId: userUID, button: .red){
                        print("Red Button Activated")
                    }
                }
            }
        }
    }
    
    private func deactivateRedButton() {
        stopFlashing()
        locationManager.deactivateButton()
    }
    
    private func fetchAllData(userId: String, completion: @escaping () -> Void) {
        self.userViewModel.fetchUserData(userId: userId) { userDataResult in
            switch userDataResult {
            case .success:
                self.userViewModel.fetchEmergencyContacts(userId: userId) { emergencyContactsResult in
                    switch emergencyContactsResult {
                    case .success:
                        self.userViewModel.fetchYellowRedMessages(userId: userId) { yellowRedMessagesResult in
                            switch yellowRedMessagesResult {
                            case .success:
                                completion()
                            case .failure(let error):
                                print("Error fetching red message: \(error.localizedDescription)")
                                completion()
                            }
                        }
                    case .failure(let error):
                        print("Error fetching emergency contacts: \(error.localizedDescription)")
                        completion()
                    }
                }
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    private func startFlashing() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            withAnimation {
                self.flash.toggle()
            }
        }
    }
    
    private func stopFlashing() {
        flash = false
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
