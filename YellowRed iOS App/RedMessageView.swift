//
//  RedMessageView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI
import FirebaseAuth

struct RedMessageView: View {
    @FocusState private var isSelecting: Bool
    @State private var messageTemplates: [String] = [
        "URGENT: I am in a high risk situation and need your personal assistance. I have activated this button discreetly, so avoid contacting me unless absolutely necessary. Please locate me via my live location.",
        "EMERGENCY: I am in serious danger and need you to contact the authorities by calling 911. I have activated this message discreetly, so avoid contacting me directly as it may pose further risk to my safety. My live location is attached to inform the operators of my whereabouts.",
        "CRISIS ALERT: I am in immediate danger and am unable to contact the police myself. Please call 911 for me and provide them with my live location.",
    ]
    @State private var selectedTemplate: Int?
    @State private var selectingTemplate: Int?
    @State private var redMessage: String = ""
    
    @State private var valid: Bool = true
    @State private var error: Bool = false
    
    @State private var next: Bool = false
    @State private var sheet: Bool = true
    
    @EnvironmentObject var userViewModel: UserViewModel
    
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
                        .fixedSize(horizontal: false, vertical: true)
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
                            if let userUID = Auth.auth().currentUser?.uid {
                                redMessage = messageTemplates[selectedTemplate!]
                                userViewModel.updateYellowRedMessages(userId: userUID, yellowMessage: yellowMessage, redMessage: redMessage) { result in
                                    switch result {
                                    case .success:
                                        print("YellowRed messages successfully added.")
                                        next = true
                                    case .failure:
                                        print("Error adding YellowRed messages.")
                                        error = true
                                    }
                                }
                            }
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
        .sheet(isPresented: $sheet){
            RedMessageNoteView(sheet: $sheet)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct RedMessageNoteView: View {
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
                    Text("Red Messages are sent during times of crisis to your emergency contacts.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 25)
                    
                    Text("These cannot be customized.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .underline()
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                    
                    Text("The Red Message templates are generalized to help you in as many situations as possible.")
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

struct RedMessageView_Previews: PreviewProvider {
    @State static var yellowMessage: String = "I'm feeling a bit uncomfortable, can we talk"
    
    static var previews: some View {
        RedMessageView(yellowMessage: yellowMessage).environmentObject(UserViewModel())
    }
}
