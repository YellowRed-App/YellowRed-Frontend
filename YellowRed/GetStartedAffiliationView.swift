//
//  GetStartedAffiliationView.swift
//  YellowRed
//
//  Created by Krish Mehta on 30/5/23.
//

import SwiftUI

struct GetStartedAffiliationView: View {
    let fullName: String
    var firstName: String {
        return fullName.components(separatedBy: " ").first ?? ""
    }
    
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

struct GetStartedAffiliationView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedAffiliationView(fullName: "John Smith")
    }
}
