//
//  LocationView.swift
//  YellowRed
//
//  Created by Krish Mehta on 8/6/23.
//

import SwiftUI

struct LocationView: View {
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

struct LocationView_Preview: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
