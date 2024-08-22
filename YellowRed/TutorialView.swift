import SwiftUI

struct TutorialView: View {
    
    @State private var note: Bool = true
    
    @State private var countdownTimer: Timer? = nil
    @State private var yellowCountdown: Int = 3
    @State private var redCountdown: Int = 5
    
    @State private var isPressingYellowButton: Bool = false
    @State private var isPressingRedButton: Bool = false
    
    @State private var yellowAlert: Bool = false
    @State private var redAlert: Bool = false
    
    @State private var yellowDone: Bool = false
    @State private var redDone: Bool = false
    
    @State private var text = [
        "Hold for three seconds",
        "Hold for five seconds",
        "On the YellowRed home page, press the profile icon to edit your information"]
    @State private var index = 0
    @State private var disappear: Bool = false
    
    @State private var isAnimated: Bool = false
    var animation: Animation {
        Animation.easeOut
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
                    Text(text[index])
                        .font(.system(size: CGFloat(30)))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .padding(.horizontal, 30)
                        .opacity(disappear || (isPressingYellowButton && !yellowDone || isPressingRedButton && !redDone) ? 0 : 1)
                    
                    if !yellowDone || redDone {
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
                                            } else {
                                                self.countdownTimer?.invalidate()
                                                self.countdownTimer = nil
                                                
                                                disappear = true
                                                yellowAlert = true
                                                isPressingYellowButton = false
                                                UIView.setAnimationsEnabled(false)
                                            }
                                        }
                                    }
                                    else {
                                        self.countdownTimer?.invalidate()
                                        self.countdownTimer = nil
                                        self.yellowCountdown = 3
                                    }
                                }, perform: { }
                                )
                                .alert("This activates the Yellow Button and sends your preselected yellow message and live location to your five emergency contacts.", isPresented: $yellowAlert) {
                                    Button("Got it", role: .cancel) {
                                        disappear = false
                                        yellowDone = true
                                        index += 1
                                    }
                                }
                                .scaleEffect(isPressingYellowButton && !yellowDone && !note ? 1.25 : 1)
                                .animation(animation)
                            
                            if isPressingYellowButton && !yellowDone && !note {
                                Text("\(yellowCountdown)")
                                    .font(.system(size: 125))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .scaledToFit()
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    if yellowDone {
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
                                            } else {
                                                self.countdownTimer?.invalidate()
                                                self.countdownTimer = nil
                                                
                                                disappear = true
                                                redAlert = true
                                                isPressingRedButton = false
                                                UIView.setAnimationsEnabled(false)
                                            }
                                        }
                                    } else {
                                        self.countdownTimer?.invalidate()
                                        self.countdownTimer = nil
                                        self.redCountdown = 5
                                    }
                                }, perform: { })
                                .alert("This activates the Red Button and sends your preselected red message and live location to your five emergency contacts. This button is for EMERGENCIES ONLY.", isPresented: $redAlert) {
                                    Button("Got it", role: .cancel) {
                                        disappear = false
                                        redDone = true
                                        index += 1
                                    }
                                }
                                .scaleEffect(isPressingRedButton && !redDone ? 1.25 : 1)
                                .animation(animation)
                            
                            if isPressingRedButton && !redDone {
                                Text("\(redCountdown)")
                                    .font(.system(size: 125))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .scaledToFit()
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    if redDone {
                        NavigationLink {
                            YellowRedView()
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.black)
                                .frame(width: 75, height: 50)
                                .overlay(
                                    Text("Done")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
                
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow, .red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("This is a tutorial to teach users how to use YellowRed. \n\n No actual messages will be sent to friends or authorities."
                        )
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                        
                        Button {
                            withAnimation {
                                note.toggle()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                                .frame(width: 150, height: 65)
                                .overlay(
                                    Text("I understand")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
                .opacity(note ? 1 : 0)
            }
        }
    }
    
    struct TutorialView_Previews: PreviewProvider {
        static var previews: some View {
            TutorialView()
        }
    }
}
