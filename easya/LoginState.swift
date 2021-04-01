//
//  LoginState.swift
//  easya
//
//  Created by Luciano Handal on 3/31/21.
//

import Foundation

struct LoginState {
    private static var loggedInKey: String = "logged_in"
    private static var usernameKey: String = "username"
    private static var groupKey: String = "group"
    
    static var logged_in: Bool? {
        didSet {
            UserDefaults.standard.setValue(logged_in, forKey: loggedInKey)
        }
    }
    
    static var username: String? {
        didSet {
            UserDefaults.standard.setValue(username, forKey: usernameKey)
        }
    }
    
    
    static var group: String? {
        didSet {
            UserDefaults.standard.setValue(group, forKey: groupKey)
        }
    }
    
    
    static func load() {
        self.username = UserDefaults.standard.string(forKey: Self.usernameKey)
    }
    
}
