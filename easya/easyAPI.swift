//
//  easyAPI.swift
//  easya
//
//  Created by Luciano Handal on 4/1/21.
//

import Foundation

import Firebase
import FirebaseAuth

let colorBg = UIColor(red: 22, green: 22, blue: 22, alpha: 1)
let colorTxt = UIColor(red: 221, green: 221, blue: 221, alpha: 1)
let colorAcc = UIColor(red: 251, green: 176, blue: 59, alpha: 1)
let colorMuted = UIColor(red: 194, green: 194, blue: 194, alpha: 1)




var base_url = "http://127.0.0.1:3000/"
var error_reaching_dict = ["result": "error",
                           "code": 000,
                           "msg": "could not reach the server"] as [String : Any]
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

func getUser() -> [String : Any]{
    //    getRequest("get_user", ["username": "lhandal"])
    return ["result": "success",
            "code": 200,
            "msg": ["group": "student",
                    "email": "lhandal@purdue.edu"]] as [String : Any]
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

func sendPostRequest(endpoint: String, data: [String:Any]) -> [String: Any]{
    let url_str = base_url + endpoint
    let url = URL(string: url_str)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: data)
    
    var ret_val : [String: Any] = [:]
    print(data)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if ((data) != nil){
            print(String(data: data!, encoding: .utf8) ?? ".")
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            ret_val = (json as? [String: Any])!
        }
        if ((response) != nil){
//            print("response", response!)
        }
        if ((error) != nil){
            print("error", error!)
        }
    }
    task.resume()
    while ret_val.count == 0 {}
    print(ret_val)
    return ret_val
    
}



func sendGetRequest(endpoint: String){
    let url_str = base_url + endpoint
    let url = URL(string: url_str)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if ((data) != nil){
            print("data", data!)
        }
        if ((response) != nil){
            print("response", response!)
        }
        if ((error) != nil){
            print("error", error!)
        }
    }
    task.resume()
    
}

func courseAutoComplete(course: String) -> String{
    let url_str = base_url + "coursesearch/" + course
    let url = URL(string: url_str)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    var ret_val = ""
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if ((data) != nil){
            ret_val = String(data: data!, encoding: .utf8) ?? "."
            print("data", ret_val)
        }
        if ((response) != nil){
//            print("response", response!)
        }
        if ((error) != nil){
            print("error", error!)
        }
    }
    task.resume()
    while ret_val == "" {}
    return ret_val
}



func getCourseDict(course: String) -> [String: Any]{
    let url_str = base_url + "course/" + course
    print(url_str)
    let url = URL(string: url_str)!
    var request = URLRequest(url: url)
    let sess = ["username": LoginState.username, "group": LoginState.group]
    print(sess)
    request.httpBody = try? JSONSerialization.data(withJSONObject: sess)
    request.httpMethod = "POST"
    
    var ret_val : [String: Any] = [:]
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if ((data) != nil){
            print(String(data: data!, encoding: .utf8) ?? ".")
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            ret_val = (json as? [String: Any])!
        }
        if ((response) != nil){
//            print("response", response!)
        }
        if ((error) != nil){
            print("error", error!)
        }
    }
    task.resume()
    while ret_val.count == 0 {}
    print(ret_val)
    return ret_val
}

func addReview(course: String, review: [String: Any]) -> [String: Any]{
    let endpoint = "new_review/\(course)"
    return sendPostRequest(endpoint: endpoint, data: review)
}

func upvotePost(postID: String) -> [String: Any] {
    let endpoint = "upvote"
    return sendPostRequest(endpoint: endpoint, data: ["username": LoginState.username!, "group": LoginState.group!, "post_ID": postID])
}

func downvotePost(postID: String) -> [String: Any]  {
    let endpoint = "downvote"
    return sendPostRequest(endpoint: endpoint, data: ["username": LoginState.username!, "group": LoginState.group!, "post_ID": postID])
    
}

