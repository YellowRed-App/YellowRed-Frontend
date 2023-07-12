//
//  RedMessageView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI

struct RedMessageView: View {
    @FocusState private var isSelecting: Bool
    @State private var messageTemplates: [String] = [
        "URGENT: I am in an immediate crisis and need your assistance. Please contact authorities or come help me. My live location has been sent to you.",
        "EMERGENCY ALERT: I am in serious danger and unable to call 911. Please, notify local authorities immediately. Check my live location for my whereabouts.",
        "CRISIS ALERT: I am in a high-risk situation and unable to reach out to the police. I need immediate assistance. Please, contact the authorities and come help. My live location is shared with you.",
    ]
    @State private var selectedTemplate: Int?
    @State private var selectingTemplate: Int?
    @State private var redMessage: String = ""
    
    @State private var valid: Bool = true
    @State private var error: Bool = false
    
    @State private var next: Bool = false
    
    let yellowMessage: String
    
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
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Red Message")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                if !isSelecting && selectingTemplate == nil {
                    Text("Please choose a message template. There is no custom message option for the Red Button!")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                VStack(spacing: 15) {
                    if selectingTemplate != nil {
                        VStack {
                            Text(messageTemplates[selectingTemplate!])
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(12.5)
                                .background(.white)
                                .colorScheme(.light)
                                .cornerRadius(10)
                                .focused($isSelecting)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        }
                        .frame(height: 200)
                        
                        HStack {
                            Button("Select", action: {
                                selectedTemplate = selectingTemplate
                                selectingTemplate = nil
                                isSelecting = false
                            })
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .padding(.horizontal, 20)
                            
                            Button("Cancel", action: {
                                selectingTemplate = nil
                                isSelecting = false
                            })
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 20)
                    } else {
                        ForEach(0..<messageTemplates.count, id: \.self) { index in
                            Text(self.messageTemplates[index])
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .padding(12.5)
                                .frame(maxWidth: .infinity)
                                .background(selectedTemplate == index ? .white.opacity(0.5) : .white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTemplate == index ? .black : .clear, lineWidth: 2.5)
                                )
                                .onTapGesture {
                                    self.selectingTemplate = index
                                    self.isSelecting = true
                                }
                        }
                    }
                    
                    if !isSelecting && selectingTemplate == nil {
                        if error {
                            Text("Please choose a template!")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        error = false
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                if !isSelecting && selectingTemplate == nil {
                    Button(action: {
                        valid = selectedTemplate != nil
                        if valid {
                            redMessage = messageTemplates[selectedTemplate!]
                            next = true
                        } else {
                            error = true
                        }
                    }) {
                        HStack {
                            Text("Next")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                    .background(
                        NavigationLink(
                            destination: NotificationView(),
                            isActive: $next,
                            label: { EmptyView() }
                        )
                    )
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct RedMessageView_Previews: PreviewProvider {
    @State static var yellowMessage: String = "I'm feeling a bit uncomfortable, can we talk"
    
    static var previews: some View {
        RedMessageView(yellowMessage: yellowMessage)
    }
}
