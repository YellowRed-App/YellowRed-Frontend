//
//  RedMessageView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI

struct RedMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var messageTemplates: [String] = [
        "I'm feeling a bit uncomfortable, can we talk?",
        "Could use some company right now, can we meet up?",
        "Feeling uneasy at my current location. Can you check on me?",
    ]
    @State private var selectedTemplate: Int?
    
    @State private var valid: Bool = true
    
    @State private var next: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "message.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                Text("Red Message")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                Text("Please choose a message template for the Red Button. There is no custom message option for the Red Button!")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    ForEach(0..<messageTemplates.count, id: \.self) { index in
                        TextField("Placeholder", text: Binding(
                            get: { self.messageTemplates[index] },
                            set: { newValue in
                                self.messageTemplates[index] = newValue
                                self.selectedTemplate = nil
                            }
                        ))
                        .foregroundColor(.black)
                        .padding()
                        .background(selectedTemplate == index ? .white.opacity(0.5) : .white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedTemplate == index ? .black : .clear, lineWidth: 2)
                        )
                        .cornerRadius(10)
                        .onTapGesture {
                            self.selectedTemplate = index
                        }
                    }
                    
                    if !valid {
                        Text("Please choose a template!")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    valid = validate()
                    next = valid
                }) {
                    HStack {
                        Text("Next")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding(12.5)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .background(
                    NavigationLink(
                        destination: PlaceholderView(),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .ignoresSafeArea(.all)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                Text("Back")
                    .foregroundColor(.white)
            }
        }
    }
    
    private func validate() -> Bool {
        return selectedTemplate != nil
    }
}

struct RedMessageView_Previews: PreviewProvider {
    static var previews: some View {
        RedMessageView()
    }
}
