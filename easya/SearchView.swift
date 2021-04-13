//
//  SearchView.swift
//  easya
//
//  Created by Luciano Handal on 4/5/21.
//

import SwiftUI
import Firebase
//import FirebaseAuth

struct Review {
    var author: String
    var grade: String
    var professor: String
    var text: String
    var semester: String
    var date: String
    var id: String
    var professor_link: URL
    var upvotes: Int
    var downvotes: Int
    var rating: Int
    var report_count: Int
    var upvote: Bool
    var downvote: Bool
    var delete: Bool
    
    init(post: [String:Any]) {
        self.author = post["author"] as! String
        self.grade = post["grade"] as! String
        self.professor = post["professor"] as! String
        self.text = post["text"] as! String
        self.semester = post["semester_taken"] as! String
        self.date = post["display_date"] as! String
        self.id = post["post_ID"] as! String
        self.upvotes = post["upvotes"] as! Int
        self.downvotes = post["downvotes"] as! Int
        self.rating = post["rating"] as! Int
        self.report_count = post["report_count"] as! Int
        self.upvote = post["upvote"] as! Bool
        self.downvote = post["downvote"] as! Bool
        self.delete = post["delete"] as! Bool
        
        self.professor_link  = URL(string: post["professor_link"] as! String) ?? URL(string: "https://www.ratemyprofessors.com")!
        
        
    }
}

struct Course {
    
    var id: String
    var name: String
    var description: String
    var rating: Int
    
    init(dict: [String : Any]) {
        self.id   = dict["id"] as! String
        self.name = dict["id"] as! String
        self.description  = dict["description"] as! String
        self.rating = dict["rating"] as! Int
    }
}


struct SearchView: View {
    @State private var course = ""
    @State private var courseID = ""
    @State private var courseFound: Bool = false
    
    @State private var id = ""
    @State private var name = ""
    @State private var description = ""
    @State private var rating = 0
    
    @State private var reviews : [Review] = []
    
    
    var body: some View {
        VStack(){
            HStack() {
                TextField("Search a class", text: $course)
                Button(action: {
                    id = ""
                    reviews = []
                    courseID = courseAutoComplete(course: course)
                    getCourseInfo(course_id: courseID)
                    
                }) {
                    Text("Go")
                }
            }.padding()
            
            
            
            if (id != ""){
                ScrollView(.vertical){
                    VStack(spacing: 50){
                        VStack{
                            VStack(alignment: .leading){
                                Text(id)
                                    .font(.title)
                                    .padding([.top, .leading, .trailing])
                                Text(name)
                                    .font(.title3)
                                    .padding([.leading, .bottom, .trailing])
                                Text(description)
                                    .font(.body)
                                    .padding()
                            }
                            
                            
                            
                            VStack(alignment: .trailing){
                                if (reviews.count > 0){
                                    HStack{
                                        Spacer()
                                        if (rating > 0){
                                            ForEach((1...rating), id: \.self){ _ in
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color("AccentColor"))
                                                
                                            }
                                        }
                                        
                                        if (rating < 5){
                                            ForEach((1...(5 - rating)), id: \.self){ _ in
                                                Image(systemName: "star")
                                                    .foregroundColor(Color("AccentColor"))
                                            }
                                        }
                                    }
                                    Text("Based on \(reviews.count) reviews")
                                        .font(.caption)
                                }
                            }.padding(.horizontal)
                        }
                        if (reviews.count > 0){
                            ForEach(0...reviews.count - 1, id: \.self){i in
                                VStack(alignment: .leading){
                                    if (reviews[i].delete) {
                                        HStack{
                                            Text("Your review")
                                                .fontWeight(.bold)
                                            Spacer()
                                            Button(action: {deleteReview(reviewId: reviews[i].id)}) {
                                                Text("Delete")
                                            }
                                        }
                                        .padding(.vertical)
                                    }
                                    HStack{
                                        Text("Professor: \(reviews[i].professor)")
                                        Spacer()
                                        Text(reviews[i].date)
                                    }
                                    if (reviews[i].grade != ""){
                                        Text("Grade: \(reviews[i].grade)")
                                    }
                                    if (reviews[i].semester != ""){
                                        Text("Semester: \(reviews[i].semester)")
                                    }
                                    
                                    if (reviews[i].text != ""){
                                        Text(reviews[i].text).padding(.vertical)
                                    }
                                    
                                    
                                    HStack{
                                        Button(action: {
                                            upvoteReview(i: i)
                                        }) {
                                            Text("\(reviews[i].upvotes)")
                                            
                                            Image(systemName: reviews[i].upvote ? "hand.thumbsup.fill" : "hand.thumbsup")
                                        }
                                        Button(action: {
                                            downvoteReview(i: i)
                                        }) {
                                            Text("\(reviews[i].downvotes)")
                                            Image(systemName: reviews[i].downvote ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                        }.padding(.horizontal)
                                        
                                        Spacer()
                                        HStack{
                                            ForEach((1...reviews[i].rating), id: \.self){ _ in
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color("AccentColor"))
                                            }
                                            if (reviews[i].rating < 5){
                                                ForEach((1...(5 - reviews[i].rating)), id: \.self){ _ in
                                                    Image(systemName: "star")
                                                        .foregroundColor(Color("AccentColor"))
                                                }
                                            }
                                            
                                        }
                                    }
                                }.padding()
                            }
                        } else{
                            Spacer()
                            VStack{
                                Text("No reviews yet.")
                                    .font(.title)
                                Text("Be the first one to review this class")
                                Image(systemName: "arrow.down")
                                    .font(.title)
                                    .foregroundColor(Color("AccentColor"))
                                    .padding(.top)
                            }
                            Spacer()
                        }
                    }.frame(maxWidth: .infinity)
                }
                
            } else {
                Spacer()
            }
            
            
            
        }
        
    }
    func deleteReview(reviewId: String){
        let db = Firestore.firestore()
        db.collection("posts").document(reviewId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                getCourseInfo(course_id: courseID)
                reviews = []
            }
        }
        
        
    }
    func getCourseInfo(course_id: String){
        let db = Firestore.firestore()
        
        let courseRef = db.collection("courses").document(course_id)
        courseRef.getDocument { (courseDoc, error) in
            if let courseDoc = courseDoc, courseDoc.exists {
                let course_dict = courseDoc.data() as [String: Any]?
                id = course_dict?["course_id"] as! String
                name = course_dict?["course_name"] as! String
                description = course_dict?["description"] as! String
                let postRef = db.collection("posts").whereField("course", isEqualTo: courseRef)
                var reviewsNum : Int = 0
                postRef.getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                reviewsNum = querySnapshot?.count ?? 0
                                print(reviewsNum)
                                for postDoc in querySnapshot!.documents {
                                    print("\(postDoc.documentID) => \(postDoc.data())")
                                   
                                    var post: [String: Any] = postDoc.data()
                                    post["post_ID"] = postDoc.documentID
                                    post["delete"] = LoginState.userposts?.contains(post["post_ID"] as! String)
                                    
                                   
                                    
                                    
                                    let fireTime : Timestamp = post["posted_date"] as! Timestamp
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateStyle = .medium
                                    dateFormatter.timeStyle = .none
                                    dateFormatter.locale = Locale(identifier: "en_US")
                                    post["posted_date"] = dateFormatter.string(from: fireTime.dateValue())
                                    post = sanitizePost(post: post)
                                    print(postDoc.documentID)
                                    post["upvote"] = LoginState.upvotes?.contains(postDoc.documentID)
                                    post["downvote"] = LoginState.downvotes?.contains(postDoc.documentID)
                                    
                                    print(post)
                                    let review = Review(post: post)
                                    reviews.append(review)
                                    rating += review.rating
                                }
                            }
                    }
                if (reviewsNum > 1){
                    rating = Int(rating/reviewsNum)
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
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
                       "post_ID"]
        
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
    
    func upvoteReview(i: Int){
        let db = Firestore.firestore()
        if (reviews[i].upvote){ // already upvoted
            reviews[i].upvotes -= 1
            LoginState.upvotes?.removeAll(where: { $0 == reviews[i].id})
        } else {// new like
            reviews[i].upvotes += 1
            if (LoginState.upvotes == nil){
                LoginState.upvotes = []
            }
            LoginState.upvotes?.append(reviews[i].id)
            
            if (reviews[i].downvote){// downvoted before
                reviews[i].downvotes -= 1
                reviews[i].downvote = false
                LoginState.downvotes?.removeAll(where: { $0 == reviews[i].id})
                db.collection("users").document(LoginState.username!).setData([ "downvoted": votesToStr(arr: LoginState.downvotes!) ], merge: true)
            }
        }
        db.collection("users").document(LoginState.username!).setData([ "upvoted": votesToStr(arr: LoginState.upvotes ?? []) ], merge: true)
        reviews[i].upvote = !reviews[i].upvote
    }
    
    func downvoteReview(i: Int){
        let db = Firestore.firestore()
        if (reviews[i].downvote){ // already downvoted
            reviews[i].downvotes -= 1
            LoginState.downvotes?.removeAll(where: { $0 == reviews[i].id})
        } else { // new downvote
            reviews[i].downvotes += 1
            if (LoginState.downvotes == nil){
                LoginState.downvotes = []
            }
            LoginState.downvotes?.append(reviews[i].id)
            
            if (reviews[i].upvote){ // upvoted before
                reviews[i].upvotes -= 1
                reviews[i].upvote = false
                LoginState.upvotes?.removeAll(where: { $0 == reviews[i].id})
                db.collection("users").document(LoginState.username!).setData([ "upvoted": votesToStr(arr: LoginState.upvotes ?? []) ], merge: true)
            }
        }
        
        db.collection("users").document(LoginState.username!).setData([ "downvoted": votesToStr(arr: LoginState.downvotes!) ], merge: true)
        
        reviews[i].downvote = !reviews[i].downvote
    }
}



struct SearhView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

