//
//  YellowRedView.swift
//  YellowRed
//
//  Created by Krish Mehta on 25/6/23.
//

import SwiftUI

struct YellowRedView: View {
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

struct YellowRedView_Previews: PreviewProvider {
    static var previews: some View {
        YellowRedView()
    }
}
