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
        "I'm feeling a bit uncomfortable, can we talk?",
        "Could use some company right now, can we meet up?",
        "Feeling uneasy at my current location. Can you check on me?",
    ]
    @State private var selectedTemplate: Int?
    @State private var selectingTemplate: Int?
    @State private var redMessage: String = ""
    
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
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Red Message")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                if selectingTemplate == nil {
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
                            
                            Spacer()
                        }
                        .frame(height: 150)
                        
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
                            .padding(.horizontal, 20)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            
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
                            .padding(.horizontal, 20)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        }
                    } else {
                        ForEach(0..<messageTemplates.count, id: \.self) { index in
                            TextField("Placeholder", text: Binding(
                                get: { self.messageTemplates[index] },
                                set: { newValue in
                                    self.messageTemplates[index] = newValue
                                    self.selectedTemplate = nil
                                }
                            ))
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .frame(maxWidth: .infinity)
                            .background(selectedTemplate == index ? .white.opacity(0.5) : .white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedTemplate == index ? .black : .clear, lineWidth: 1)
                            )
                            .onTapGesture {
                                self.selectingTemplate = index
                                self.isSelecting = true
                            }
                        }
                    }
                    
                    if !valid {
                        Text("Please choose a template!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    valid = selectedTemplate != nil
                    if valid {
                        redMessage = messageTemplates[selectedTemplate!]
                        next = true
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
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .background(
                    NavigationLink(
                        destination: YellowRedView(),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
        }
    }
    
}

struct RedMessageView_Previews: PreviewProvider {
    static var previews: some View {
        RedMessageView()
    }
}
