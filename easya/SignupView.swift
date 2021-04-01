//
//  SignupView.swift
//  easya
//
//  Created by Luciano Handal on 3/31/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignupView: View {
    @State private var email_or_username = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirm_psw = ""
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
                        .padding(.top)
                        .padding(.trailing)
                        .padding(.leading)
                    
                    SecureField("Confirm Password", text: $confirm_psw)
                        .padding(.bottom)
                        .padding(.trailing)
                        .padding(.leading)
                }
                Text(error_msg)
                NavigationLink(destination: signupMsg(), isActive: $loginSuccess) {
                    Button(action: {
                        signup()
                    }) {
                        Text("Sign Up")
                            .padding()
                            .frame(width: 300, height: 50)
                    }.padding()
                }

                
                
                Spacer()
                HStack(spacing: 0) {
                    Text("Already have an account? ")
                    NavigationLink(destination: LoginView()) {
                        Text("Sign Up")
                    }
                }
                Spacer()

            }
        }
    }

    
    func validateInfo() -> Bool {
        let p_email_reg = try! NSRegularExpression(pattern: "[^@ \t\r\n]+@purdue.edu")
        let email_reg = try! NSRegularExpression(pattern: "[^@ \t\r\n]+@[^@ \t\r\n]+.[^@ \t\r\n]+")
        let psw_reg = try! NSRegularExpression(pattern: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$")
        
        let email_range = NSRange(location: 0, length: email_or_username.utf16.count)
        let psw_range = NSRange(location: 0, length: password.utf16.count)
        
        
        
        
        if (email_reg.firstMatch(in: email_or_username, options: [], range: email_range) != nil) {
            if (p_email_reg.firstMatch(in: password, options: [], range: email_range) != nil) {
                print("Purdue email provided")
                email = email_or_username
                username = String(email.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: true)[0])
                error_msg = ""
            } else {
                print("None Purdue email provided")
                error_msg = "You need to sign up with your Purdue email or career ID."
                return false
            }
        } else {
            print("Career ID provided")
            username = email_or_username
            email = username + "@purdue.edu"
            error_msg = ""
        }
        
        if (psw_reg.firstMatch(in: password, options: [], range: psw_range) != nil) {
            print("Password matches the requierements")
            error_msg = ""
        } else {
            print("Weak password")
            error_msg = "You need to use a password of at least 8 charcters containing an uppercase letter, a lower case letter, a number, an special symbol."
            return false
        }
        
        return true
    }
    
    func signup() {
        print(email, password)
        if (!validateInfo()){
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                        error_msg = "Cannot sign up"
                    } else {
                        print("Sign up successful")
                        loginSuccess = true
                    }
        }
    }
    
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

