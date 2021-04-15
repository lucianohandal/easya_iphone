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

func deleteReview(reviewId: String){
    let db = Firestore.firestore()
    db.collection("posts").document(reviewId).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
            LoginState.userposts?.removeAll(where: { $0 == reviewId})
        }
    }
}

func votesToStr(arr: [String]) -> String{
    var str = "["
    var first = true
    for e in arr{
        if (first){
            str = str + "'\(e)'"
            first = false
        } else {
            str = str + "',\(e)'"
        }
    }
    str = str + "]"
    return str
}

func upvoteReview(review: Review){
    print(review)
    var upvotes = review.upvotes
    var downvotes = review.downvotes
    let db = Firestore.firestore()
    if (review.upvote){ // already upvoted
        upvotes -= 1
        LoginState.upvotes?.removeAll(where: { $0 == review.id})
    } else {// new like
        upvotes += 1
        if (LoginState.upvotes == nil){
            LoginState.upvotes = []
        }
        LoginState.upvotes?.append(review.id)
        
        if (review.downvote){// downvoted before
            downvotes -= 1
            LoginState.downvotes?.removeAll(where: { $0 == review.id})
        }
    }
    print(LoginState.upvotes!)
    db.collection("posts").document(review.id).setData(["upvotes": upvotes,
                                                        "downvotes": downvotes], merge: true)
    db.collection("users").document(LoginState.username!)
        .setData(["upvoted": votesToStr(arr: LoginState.upvotes ?? []),
                  "downvoted": votesToStr(arr: LoginState.downvotes!) ], merge: true)
}

func downvoteReview(review: Review){
    let db = Firestore.firestore()
    var upvotes = review.upvotes
    var downvotes = review.downvotes
    if (review.downvote){ // already downvoted
        downvotes -= 1
        LoginState.downvotes?.removeAll(where: { $0 == review.id})
    } else { // new downvote
        downvotes += 1
        if (LoginState.downvotes == nil){
            LoginState.downvotes = []
        }
        LoginState.downvotes?.append(review.id)
        
        if (review.upvote){ // upvoted before
            upvotes -= 1
            LoginState.upvotes?.removeAll(where: { $0 == review.id})
            db.collection("users").document(LoginState.username!).setData([ "upvoted": votesToStr(arr: LoginState.upvotes ?? []) ], merge: true)
        }
    }
    db.collection("posts").document(review.id).setData(["upvotes": upvotes, "downvotes": downvotes], merge: true)
    db.collection("users").document(LoginState.username!)
        .setData(["upvoted": votesToStr(arr: LoginState.upvotes ?? []),
                  "downvoted": votesToStr(arr: LoginState.downvotes!) ], merge: true)
}


func sanitizePost(post: [String: Any]) -> [String: Any] {
    var p = post
    let strKeys = ["author",
                   "grade",
                   "professor",
                   "text",
                   "semester_taken",
                   "display_date",
                   "professor_link",
                   "tags",
                   "post_ID",
                   "course_id"]
    
    let intKeys = ["upvotes",
                   "downvotes",
                   "rating",
                   "report_count"]
    
    for key in strKeys{
        if (p[key] == nil){
            p[key] = ""
            continue
        }
        if let str = p[key] as? String {
            if str == "<null>"{
                p[key] = ""
            }
        }
        else {
            p[key] = ""
        }
    }
    for key in intKeys{
        if (p[key] == nil) {
            p[key] = 0
            continue
        }
        if (p[key] as? Int) != nil {
            continue
        } else {
            p[key] = 0
        }
    }
    return p
}
