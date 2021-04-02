//
//  easyAPI.swift
//  easya
//
//  Created by Luciano Handal on 4/1/21.
//

import Foundation

import Firebase
import FirebaseAuth


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

//func getRequest(endpoint: String, data[String : Any]) -> [String : Any]{
//    let url = URL(string: base_url + endpoint)!
//    var ret = error_reaching_dict
//
//    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//        guard let data = data else {return}
//        ret = convertToDictionary(text: String(data: data, encoding: .utf8)!) ?? error_reaching_dict
//    }
//
//    task.resume()
//    return ret
//}

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

//func dictToJSONstr(dict: [String:Any]){
//    if let theJSONData = try? JSONSerialization.data(
//        withJSONObject: dict,
//        options: []) {
//        let theJSONText = String(data: theJSONData,
//                                   encoding: .ascii)
//        print("JSON string = \(theJSONText!)")
//        return theJSONText
//    }
//}

func sendPostRequest(endpoint: String, data: [String:Any]){
    let url_str = base_url + endpoint
    let url = URL(string: url_str)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: data)
    
    print(url_str, data)
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
