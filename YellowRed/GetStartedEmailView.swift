//
//  GetStartedEmailView.swift
//  YellowRed
//
//  Created by Krish Mehta on 30/5/23.
//

import SwiftUI

struct GetStartedEmailView: View {
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

struct GetStartedEmailView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedEmailView()
    }
}
