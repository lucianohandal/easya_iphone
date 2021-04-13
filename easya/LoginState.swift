//
//  LoginState.swift
//  easya
//
//  Created by Luciano Handal on 3/31/21.
//

import Foundation
import Firebase



struct LoginState {
    private static var loggedInKey: String = "logged_in"
    private static var usernameKey: String = "username"
    private static var emailKey: String = "email"
    private static var groupKey: String = "group"
    private static var upvotesKey: String = "upvotes"
    private static var downvotesKey: String = "downvotes"
    private static var userRefKey: String = "userRef"
    
    private static var showLoginAlertKey: String = "showLoginAlert"
    private static var alertTitleKey: String = "alertTitle"
    private static var alertTextKey: String = "alertText"
    
    static var userRef: String? {
        didSet {
            UserDefaults.standard.setValue(userRef, forKey: userRefKey)
        }
    }
    
    static var upvotes: [String]? {
        didSet {
            UserDefaults.standard.setValue(upvotes, forKey: upvotesKey)
        }
    }
    
    static var downvotes: [String]? {
        didSet {
            UserDefaults.standard.setValue(downvotes, forKey: downvotesKey)
        }
    }
    
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
    
    static var email: String? {
        didSet {
            UserDefaults.standard.setValue(email, forKey: emailKey)
        }
    }
    
    
    
    static var group: String? {
        didSet {
            UserDefaults.standard.setValue(group, forKey: groupKey)
        }
    }
    
    static var showLoginAlert: Bool? {
        didSet {
            UserDefaults.standard.setValue(showLoginAlert, forKey: showLoginAlertKey)
        }
    }
    
    static var alertTitle: String? {
        didSet {
            UserDefaults.standard.setValue(alertTitle, forKey: alertTitleKey)
        }
    }
    
    static var alertText: String? {
        didSet {
            UserDefaults.standard.setValue(alertText, forKey: alertTextKey)
        }
    }
    
    static func load() {
        self.logged_in = UserDefaults.standard.bool(forKey: Self.loggedInKey)
        self.username = UserDefaults.standard.string(forKey: Self.usernameKey)
        self.email = UserDefaults.standard.string(forKey: Self.emailKey)
        self.group = UserDefaults.standard.string(forKey: Self.groupKey)
        self.userRef = UserDefaults.standard.string(forKey: Self.userRefKey)
        self.upvotes = UserDefaults.standard.array(forKey: Self.upvotesKey) as? [String]
        self.downvotes = UserDefaults.standard.array(forKey: Self.downvotesKey) as? [String]
        self.showLoginAlert = false
        self.alertTitle = ""
        self.alertText = ""
    }
    
}
