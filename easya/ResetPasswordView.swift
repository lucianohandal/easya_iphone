//
//  ResetPasswordView.swift
//  easya
//
//  Created by Luciano Handal on 4/2/21.
//
// lhandal
// Qwerty12!

import SwiftUI
import Firebase
import FirebaseAuth

struct ResetPassword: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var email_or_username = ""
    @State private var e_or_u = ""
    @State private var username = ""
    @State private var email = ""
    @State private var resetSuccess = false
    
    
    
    var body: some View {
        NavigationView {
            VStack() {
                Spacer()

                Text("easyA")
                    .font(.title)
                    .padding()
                
                Text("Enter your Purdue email or Career ID to reset your password")
                    .padding()
                
                TextField("Email or Career ID", text: $e_or_u)
                    .padding()
                
                NavigationLink(destination: LoginView(), isActive: $resetSuccess) {
                    Button(action: {
                        setVars()
                        resetPassword(email: email)
                        resetSuccess = true
                    }) {
                        Text("Reset Password")
                            .padding()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .frame(width: 300, height: 50)
                    }.padding()
                }

                
                
                Spacer()
                HStack(spacing: 0) {
                    NavigationLink(destination: LoginView()) {
                        Text("Cancel")
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                }
                Spacer()

            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    func setVars() {
        email_or_username = e_or_u
        email_or_username = email_or_username.lowercased()
        let regex = try! NSRegularExpression(pattern: "[^@ \t\r\n]+@purdue.edu")
        let range = NSRange(location: 0, length: email_or_username.utf16.count)
        if (regex.firstMatch(in: email_or_username, options: [], range: range) != nil) {
            email = email_or_username
            username = String(email.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: true)[0])
        } else {
            username = email_or_username
            email = username + "@purdue.edu"
        }

    }


}


struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}



