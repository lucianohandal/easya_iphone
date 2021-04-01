//
//  easyaApp.swift
//  easya
//
//  Created by Luciano Handal on 3/29/21.
//

import SwiftUI
import Firebase

@main
struct easyaApp: App {
    init(){
        FirebaseApp.configure()
        LoginState.load()
    }
    
    var body: some Scene {
        
        WindowGroup {
            if LoginState.logged_in ?? false {
                ContentView()
            } else {
                LoginView()
            }
        }
        
    }
}
