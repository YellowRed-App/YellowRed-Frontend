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
        "I’m heading out and would appreciate it if you kept a watchful eye on me during my trip. Please monitor my live location until I reach my destination.",
        "I’m about to go on a commute that I’m not entirely comfortable with. If you could accompany me virtually by monitoring my live location, that’d be great.",
        "Just letting you know that I’m walking home alone from a night out. I’d appreciate it if you could monitor my live location to make sure I reach my destination safely."
    ]
    @State private var editingTemplate: Int?
    @State private var selectedTemplate: Int?
    @State private var previousSelectedTemplate: Int?
    @State private var customMessage: String = ""
    @State private var previousCustomMessage: String = ""
    @State private var yellowMessage: String = ""
    
    @State private var valid: Bool = true
    @State private var error: Bool = false
    
    @State private var next: Bool = false
    @State private var sheet: Bool = true
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
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
                    
                    if !isEditing && editingTemplate == nil {
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
                                    previousSelectedTemplate = selectedTemplate
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
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                                .padding(.horizontal, 20)
                                
                                Button("Cancel", action: {
                                    editingTemplate = nil
                                    isEditing = false
                                    customMessage = previousCustomMessage
                                    if previousCustomMessage.isEmpty {
                                        selectedTemplate = previousSelectedTemplate
                                    } else {
                                        selectedTemplate = nil
                                    }
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
                                    self.previousSelectedTemplate = self.selectedTemplate
                                    self.previousCustomMessage = self.customMessage
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
                                        self.previousCustomMessage = customMessage
                                        self.selectedTemplate = nil
                                        self.previousSelectedTemplate = nil
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
                            if error {
                                Text("Please choose a template or create your own!")
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
                    
                    if !isEditing && editingTemplate == nil {
                        Button(action: {
                            valid = (selectedTemplate != nil && !messageTemplates[selectedTemplate!].isEmpty) || !customMessage.isEmpty
                            if valid {
                                yellowMessage = selectedTemplate != nil ? messageTemplates[selectedTemplate!] : customMessage
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
                                destination: RedMessageView(yellowMessage: yellowMessage).environmentObject(userViewModel),
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
            .sheet(isPresented: $sheet){
                YellowMessageNoteView(sheet: $sheet)
            }
        }
        .navigationBarBackButtonHidden(true)
        .endEditingOnTap()
    }
}

struct YellowMessageNoteView: View {
    @Environment (\.dismiss) var dismiss
    
    @Binding var sheet: Bool
    
    var body: some View{
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.yellow, .red]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Yellow Messages are sent during times of discomfort to your emergency contacts.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 25)
                    
                    Text("This could be walking home from the library, getting in a ride share, or being out on the town alone.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 25)
                    
                    Button {
                        sheet = false
                        dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 75, height: 50)
                            .foregroundColor(.blue)
                            .overlay(
                                Text("OK")
                                    .font(.system(size: 25))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.horizontal, 25)
            }
        }
    }
}

struct YellowMessageView_Previews: PreviewProvider {
    static var previews: some View {
        YellowMessageView().environmentObject(UserViewModel())
    }
}
