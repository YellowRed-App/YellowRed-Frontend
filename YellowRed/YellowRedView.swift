//
//  YellowRedView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI

struct YellowRedView: View {
    @State private var profile: Bool = false
    
    @State private var yellowButton: Bool = false
    @State private var redButton: Bool = false
    
    @State private var countdown: Int = 5
    @State private var timer: Timer? = nil
    
    @State private var isPressing: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: yellowButton ? Gradient(colors: [.yellow, .yellow]) : Gradient(colors: [.blue, .white]),
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
                
                ZStack {
                    Circle()
                        .fill(.yellow)
                        .frame(width: 200, height: 200)
                        .disabled(yellowButton)
                        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                            if !yellowButton {
                                isPressing = pressing
                                if pressing {
                                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                        if self.countdown > 0 {
                                            self.countdown -= 1
                                        } else {
                                            self.timer?.invalidate()
                                            self.timer = nil
                                            self.yellowButton.toggle()
                                            self.yellowButtonAction()
                                        }
                                    }
                                } else {
                                    self.timer?.invalidate()
                                    self.timer = nil
                                    self.countdown = 5
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
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func yellowButtonAction() {
        // TODO: yellow button
    }
    
    private func redButtonAction() {
        // TODO: red button
    }
}

struct YellowRedView_Previews: PreviewProvider {
    static var previews: some View {
        YellowRedView()
    }
}
