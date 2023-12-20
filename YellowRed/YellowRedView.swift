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
    
    @State private var yellowCountdown: Int = 3
    @State private var redCountdown: Int = 5
    @State private var countdownTimer: Timer? = nil
    
    @State private var yellowHint: Bool = false
    @State private var redHint: Bool = false
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
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .opacity((isPressingYellowButton || isPressingRedButton) ? 0 : 1)
                    
                    ZStack {
                        Circle()
                            .fill(.yellow)
                            .frame(width: 200, height: 200)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                isPressingYellowButton = pressing
                                if pressing {
                                    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                        if self.yellowCountdown > 1 {
                                            self.yellowCountdown -= 1
                                            GlobalHapticManager.shared.triggerHapticFeedback(0.25)
                                        } else {
                                            self.countdownTimer?.invalidate()
                                            self.countdownTimer = nil
                                            self.yellowButton.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                self.isPressingYellowButton = false
                                            }
                                            UIView.setAnimationsEnabled(false)
                                        }
                                    }
                                } else {
                                    self.countdownTimer?.invalidate()
                                    self.countdownTimer = nil
                                    self.yellowCountdown = 3
                                    if self.yellowCountdown > 1 {
                                        self.yellowHint = true
                                        self.redHint = false
                                        self.hintTimer?.invalidate()
                                        self.hintTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                                            self.yellowHint = false
                                        }
                                    }
                                }
                            }, perform: { })
                            .fullScreenCover(isPresented: $yellowButton) {
                                YellowButtonView(yellowButton: $yellowButton)
                            }
                        
                        if isPressingYellowButton && yellowCountdown <= 3 {
                            Text("\(yellowCountdown)")
                                .font(.system(size: 125))
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .scaledToFit()
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
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                isPressingRedButton = pressing
                                if pressing {
                                    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                        if self.redCountdown > 1 {
                                            self.redCountdown -= 1
                                            GlobalHapticManager.shared.triggerHapticFeedback(0.25)
                                        } else {
                                            self.countdownTimer?.invalidate()
                                            self.countdownTimer = nil
                                            self.redButton.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                self.isPressingRedButton = false
                                            }
                                            UIView.setAnimationsEnabled(false)
                                        }
                                    }
                                } else {
                                    self.countdownTimer?.invalidate()
                                    self.countdownTimer = nil
                                    self.redCountdown = 5
                                    if self.redCountdown > 1 {
                                        self.redHint = true
                                        self.yellowHint = false
                                        self.hintTimer?.invalidate()
                                        self.hintTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                                            self.redHint = false
                                        }
                                    }
                                }
                            }, perform: { })
                            .fullScreenCover(isPresented: $redButton) {
                                RedButtonView(redButton: $redButton)
                            }
                        
                        if isPressingRedButton && redCountdown <= 5 {
                            Text("\(redCountdown)")
                                .font(.system(size: 125))
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .scaledToFit()
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
        .onAppear(perform: GlobalHapticManager.shared.startHapticEngine)
        .navigationBarBackButtonHidden(true)
    }
}

struct YellowButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var yellowButton: Bool
    
    @State private var flash: Bool = false
    
    @StateObject private var userViewModel = UserViewModel()
    
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
        .onDisappear(perform: deactivateYellowButton)
    }
    
    private func activateYellowButton() {
        GlobalHapticManager.shared.startHapticEngine()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            GlobalHapticManager.shared.triggerHapticFeedback(5)
        }
        startFlashing()
        if let userUID = Auth.auth().currentUser?.uid {
            fetchAllData(userId: userUID)
        }
    }
    
    private func deactivateYellowButton() {
        GlobalHapticManager.shared.stopHapticEngine()
        stopFlashing()
        sendEmergencyMessageIfNeeded(message: "Yellow Button Deactivated")
    }
    
    private func fetchAllData(userId: String) {
        userViewModel.fetchUserData(userId: userId) {
            userViewModel.fetchEmergencyContacts(userId: userId) {
                userViewModel.fetchYellowRedMessages(userId: userId) {
                    let yellowMessage = userViewModel.yellowMessage
                    sendEmergencyMessageIfNeeded(message: yellowMessage)
                }
            }
        }
    }
    
    private func sendEmergencyMessageIfNeeded(message: String) {
        guard !userViewModel.emergencyContacts.isEmpty, !userViewModel.yellowMessage.isEmpty else {
            print("Emergency contacts or message are not available yet.")
            return
        }
        
        let emergencyContactNumbers = userViewModel.emergencyContacts.map { $0.phoneNumber }
        
        sendEmergencyMessage(contacts: emergencyContactNumbers, message: message)
    }
    
    private func sendEmergencyMessage(contacts: [String], message: String) {
        guard let url = URL(string: "https://us-central1-yellowred-app.cloudfunctions.net/sendEmergencySMS") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = ["contacts": contacts, "message": message]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        print("Sending payload: \(payload)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending SMS: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status code: \(httpResponse.statusCode)")
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data: \(dataString)")
            }
        }.resume()
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
                            self.redButton = false
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
        GlobalHapticManager.shared.startHapticEngine()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
