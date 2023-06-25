//
//  RedMessageView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI

struct RedMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow, Color.red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
        }
    }
}

struct RedMessageView_Previews: PreviewProvider {
    static var previews: some View {
        RedMessageView()
    }
}
