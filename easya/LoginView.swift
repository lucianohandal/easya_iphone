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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var email_or_username = ""
    @State private var e_or_u = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var error_msg = ""
    @State private var loginSuccess = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertText = ""
    
    
    var body: some View {
        NavigationView {
            VStack() {
                Spacer()

                Text("easyA")
                    .font(.title)
                    .padding()
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertText) , dismissButton: .default(Text("Ok")))
                    }
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Email or Career ID", text: $e_or_u)
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .padding()
                }
                NavigationLink(destination: ResetPassword()) {
                    Text("Forgot password?")
                        .padding()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .frame(width: 300, height: 50)
                }
                
                Text(error_msg)
                NavigationLink(destination: HomeView(), isActive: $loginSuccess) {
                    Button(action: {
                        setVars()
                        login()
                    }) {
                        Text("Log In")
                            .padding()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .frame(width: 300, height: 50)
                    }.padding()
                }

                
                
                Spacer()
                HStack(spacing: 0) {
                    Text("Don't have an account? ")
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                }
                Spacer()

            }.onAppear {
                initLogin()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func initLogin(){
        showAlert = LoginState.showLoginAlert ?? false
        alertTitle = LoginState.alertTitle ?? ""
        alertText = LoginState.alertText ?? ""
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
    func getGroup(username: String) -> String{
        let response = getUser()
        print(response)
        if (response["code"] as! Int == 200){
            let user_data = response["msg"] as! [String: Any]
            return user_data["group"] as! String
        }
        return "failed"
    }
    func login() {
        print("Logging in \(email) with password \(password)")
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                        alertTitle = "Could not log in"
                        alertText = error?.localizedDescription ?? ""
                        showAlert = true
                    } else {
                        loginSuccess = true
                        LoginState.logged_in = true
                        LoginState.username = username
                        LoginState.email = email
                        LoginState.group = getGroup(username: username)
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


