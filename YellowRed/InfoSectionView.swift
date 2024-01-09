//
//  InfoSectionView.swift
//  YellowRed
//
//  Created by Krish Mehta on 5/7/23.
//

import SwiftUI

struct InfoView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
        }
    }
}

struct SectionView<Content: View>: View {
    @State private var next: Bool = false
    
    var title: String
    var content: Content
    var destinationView: AnyView?
    
    init(title: String, @ViewBuilder content: () -> Content, destinationView: AnyView? = nil) {
        self.title = title
        self.content = content()
        self.destinationView = destinationView
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if let destinationView = destinationView {
                        Button(action: {
                            next = true
                        }) {
                            Label("Edit", systemImage: "square.and.pencil")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }.sheet(isPresented: $next) {
                            destinationView
                        }
                    }
                }
                .padding(.bottom, 10)
                content
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        LinearGradient(
                            colors: [.yellow, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 5
                    )
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}
