//
//  signupMsg.swift
//  easya
//
//  Created by Luciano Handal on 3/31/21.
//

import SwiftUI

struct signupMsg: View {
    var body: some View {
     
        VStack() {
            
            Text("Thank you for signing up!")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                HStack(spacing: 0) {
                    Text("Please confirm you email to ")
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                    }
                }
                
            }
        }
    }
}

struct signupMsg_Previews: PreviewProvider {
    static var previews: some View {
        signupMsg()
    }
}
