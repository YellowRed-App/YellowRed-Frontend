//
//  YellowMessageView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI

struct YellowMessageView: View {
    @FocusState private var isEditing: Bool
    @State private var messageTemplates: [String] = [
        "I'm heading out and would feel safer if someone kept an eye on my journey. Would you mind monitoring my live location?",
        "I'm about to take a trip that I'm not entirely comfortable with. Could you accompany me virtually by keeping tabs on my live location?",
        "Just letting you know, I'm out alone right now and it would put me at ease if you could check up on me periodically. You've been sent my live location.",
    ]
    @State private var selectedTemplate: Int?
    @State private var editingTemplate: Int?
    @State private var customMessage: String = ""
    @State private var yellowMessage: String = ""
    
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
                
                Text("Yellow Message")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                if !isEditing {
                    Text("Please choose and edit a message template or create your own custom message!")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                VStack(spacing: 15) {
                    if editingTemplate != nil {
                        VStack {
                            TextEditor(text: $messageTemplates[editingTemplate!])
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .frame(height: 150)
                                .frame(maxWidth: .infinity)
                                .padding(12.5)
                                .background(.white)
                                .colorScheme(.light)
                                .cornerRadius(10)
                                .focused($isEditing)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        }
                        
                        HStack {
                            Button("Select", action: {
                                selectedTemplate = editingTemplate
                                editingTemplate = nil
                                isEditing = false
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
                                editingTemplate = nil
                                isEditing = false
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
                                    self.customMessage = ""
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
                                    .stroke(selectedTemplate == index ? .black : .clear, lineWidth: 2.5)
                            )
                            .onTapGesture {
                                self.editingTemplate = index
                                self.isEditing = true
                            }
                        }
                        
                        ZStack(alignment: .leading) {
                            if customMessage.isEmpty {
                                Text("Custom Yellow Button Message")
                                    .opacity(0.5)
                            }
                            
                            TextField("Custom Yellow Button Message", text: Binding(
                                get: { self.customMessage },
                                set: { newValue in
                                    self.customMessage = newValue
                                    self.selectedTemplate = nil
                                }
                            ))
                        }
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .background(!customMessage.isEmpty ? .white.opacity(0.5) : .white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(!customMessage.isEmpty ? .black : .clear, lineWidth: 2.5)
                        )
                    }
                    
                    if !isEditing && editingTemplate == nil {
                        if !valid {
                            Text("Please choose a template or create your own!")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    valid = (selectedTemplate != nil && !messageTemplates[selectedTemplate!].isEmpty) || !customMessage.isEmpty
                    if valid {
                        yellowMessage = selectedTemplate != nil ? messageTemplates[selectedTemplate!] : customMessage
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
                .background(
                    NavigationLink(
                        destination: RedMessageView(),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
        .endEditingOnTap()
    }
}

struct YellowMessageView_Previews: PreviewProvider {
    static var previews: some View {
        YellowMessageView()
    }
}
