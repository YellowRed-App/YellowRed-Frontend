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

    var body: some View {
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

                Button(action: {
                    yellowButton.toggle()
                    yellowButtonAction()
                }) {
                    Circle()
                        .fill(.yellow)
                        .frame(width: 200, height: 200)
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
