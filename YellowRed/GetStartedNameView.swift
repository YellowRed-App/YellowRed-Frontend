//
//  GetStartedNameView.swift
//  YellowRed
//
//  Created by Krish Mehta on 26/5/23.
//

import SwiftUI

final class GetStartedNameViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var isFullNameValid: Bool = true
    
}


struct GetStartedNameView: View {
    @StateObject private var model = GetStartedNameViewModel()
    
    @State private var next: Bool = false
    
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
                    Text("Get Started")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("Enter Full Name")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    ZStack(alignment: .leading) {
                        TextField("John Smith", text: $model.fullName)
                            .autocapitalization(.words)
                        //                            .keyboardType(.alphabet)
                        
                        if model.fullName.isEmpty {
                            Text("John Smith")
                                .opacity(0.5)
                        }
                    }
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding(12.5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: model.isFullNameValid ? 0 : 2.5)
                    )
                    
                    if !model.isFullNameValid {
                        Text("Please enter a valid name!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        model.isFullNameValid = InputValidator.validateFullName(model.fullName)
                        if model.isFullNameValid {
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
                            destination: GetStartedNumberView(fullName: model.fullName),
                            isActive: $next,
                            label: { EmptyView() }
                        )
                    )
                }
                .padding(.horizontal, 40)
            }
            .endEditingOnTap()
        }
    }
}

struct GetStartedNameView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedNameView()
    }
}
