//
//  HomeView.swift
//  easya
//
//  Created by Luciano Handal on 4/2/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            TabView {
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                
                AddReviewView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                    }
                
                UserView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                    }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct SearchView: View {
    @State private var course = ""
    @State private var course_sug = ""
    
    var body: some View {
        VStack() {
            TextField("Search a class", text: $course)
                .padding()
            Text(course_sug)
            Button(action: {
                course_sug = courseAutoComplete(course: course)
                
            }) {
                Text("Send Request")
            }
        }
        
    }
}

struct AddReviewView: View {
    var body: some View {
        Text("Addreview")
            .padding()
    }
}

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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
