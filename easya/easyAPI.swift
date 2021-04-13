//
//  easyAPI.swift
//  easya
//
//  Created by Luciano Handal on 4/1/21.
//sahnik

import Foundation

import Firebase
import FirebaseAuth

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func logout(){
    let firebaseAuth = Auth.auth()
    do {
        try firebaseAuth.signOut()
    } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
    }
    LoginState.logged_in = false
    LoginState.showLoginAlert = false
    LoginState.alertTitle = nil
    LoginState.alertText = nil
    LoginState.username = nil
    LoginState.email = nil
    LoginState.group = nil
}

func resetPassword(email: String) {
    if (email == ""){
        return
    }
    Auth.auth().sendPasswordReset(withEmail: email) { error in
        print(error ?? "Reset email sent")
        return
    }
    LoginState.showLoginAlert = true
    LoginState.alertTitle = "Reset email sent"
    LoginState.alertText = "Please go to the link on your email to reset the password"
}

func voteStrToArr(str: String) -> [String]{
    var s = str
    s = s.replacingOccurrences(of: "'", with: "", options: .literal, range: nil)
    s = s.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    s = s.replacingOccurrences(of: "[", with: "", options: .literal, range: nil)
    s = s.replacingOccurrences(of: "]", with: "", options: .literal, range: nil)
    return s.components(separatedBy: ",")
}

func strToArr(str: String) -> [String]{
    var s = str
    s = s.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
    s = s.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    s = s.replacingOccurrences(of: "[", with: "", options: .literal, range: nil)
    s = s.replacingOccurrences(of: "]", with: "", options: .literal, range: nil)
    return s.components(separatedBy: ",")
}

func courseSuggestions(course: String) -> [String]{
    let url_str = "https://www.easya.app/coursesearch/" + course
    let url = URL(string: url_str)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    var sugs: [String] = []
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if ((data) != nil){
            var jsonString = String(data: data!, encoding: .utf8) ?? "."
            jsonString = jsonString.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
            jsonString = jsonString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            jsonString = jsonString.replacingOccurrences(of: "[", with: "", options: .literal, range: nil)
            jsonString = jsonString.replacingOccurrences(of: "]", with: "", options: .literal, range: nil)
            sugs = jsonString.components(separatedBy: ",")
        }
        if ((response) != nil){
//            print("response", response!)
        }
        if ((error) != nil){
            print("error", error!)
        }
    }
    task.resume()
    while sugs.count == 0 {}
    print(sugs)
    return sugs
}

func courseAutoComplete(course: String) -> String{
    let sugs = courseSuggestions(course: course)
    return sugs[0]
}


