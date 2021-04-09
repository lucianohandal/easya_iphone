//
//  UserView.swift
//  easya
//
//  Created by Luciano Handal on 4/5/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct UserView: View {
    @State private var logoutSuccess = false
    
    var body: some View {
        VStack() {
            NavigationLink(destination: LoginView(), isActive: $logoutSuccess) {
                Button(action: {
                    logout()
                    logoutSuccess = true
                }) {
                    Text("Log out")
                        .padding()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .frame(width: 300, height: 50)
                }
                .padding()
            }
            NavigationLink(destination: LoginView(), isActive: $logoutSuccess) {
                Button(action: {
                    resetPassword(email: LoginState.email ?? "")
                    logout()
                    logoutSuccess = true
                }) {
                    Text("Reset Password")
                        .padding()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .frame(width: 300, height: 50)
                }
                .padding()
            }
        }
    }
    
    
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

