//
//  LoginView.swift
//  easya
//
//  Created by Luciano Handal on 3/29/21.
//
// lhandal
// Qwerty12!

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State private var email_or_username = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State var error_msg = ""
    @State var loginSuccess = false
    
    var body: some View {
        NavigationView {
            VStack() {
                Spacer()

                Text("easyA")
                    .font(.title)
                    .padding()
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Email or Career ID", text: $email_or_username)
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .padding()
                }
                Text(error_msg)
                NavigationLink(destination: SignupView(), isActive: $loginSuccess) {
                    Button(action: {
                        setVars()
                        login()
                    }) {
                        Text("Log In")
                            .padding()
                            .frame(width: 300, height: 50)
                    }.padding()
                }

                
                
                Spacer()
                HStack(spacing: 0) {
                    Text("Don't have an account? ")
                    NavigationLink(destination: ContentView()) {
                        Text("Sign Up")
                    }
                }
                Spacer()

            }
        }
    }
    func setVars() {
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
    func login() {
        print(email, password)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                        error_msg = "Cannot log in"
                    } else {
                        loginSuccess = true
                        LoginState.logged_in = true
                        LoginState.logged_in = true
                        LoginState.username = username
                        LoginState.group = "student"
                        print("success")
                    }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


