//
//  SearchView.swift
//  easya
//
//  Created by Luciano Handal on 4/5/21.
//

import SwiftUI
import Firebase
//import FirebaseAuth

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
    
    @State var reviews : [Review] = []
    
    
    var body: some View {
        VStack(){
            HStack() {
                TextField("Search a class", text: $course)
                Button(action: {
                    rating = 0
                    id = ""
                    reviews = []
                    courseID = courseAutoComplete(course: course)
                    getCourseInfo(course_id: courseID)
                    
                }) {
                    Text("Go")
                }
            }
            .padding()
            .background(Color("BackgroundColor"))
            .cornerRadius(16)
            
            
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
                            }
                            .padding([.leading, .bottom, .trailing])
                        }
                        .background(Color("BackgroundColor"))
                        .cornerRadius(16)
                        if (reviews.count > 0){
                            ForEach(0...reviews.count - 1, id: \.self){i in
                                ReviewCell(review: reviews[i])
                            }
                            Spacer()
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
            
            
            
        }.padding(.horizontal, 16.0)
        
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
                            post["userScreen"] = false
                            
//                            let fireTime : Timestamp = post["posted_date"] as! Timestamp
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateStyle = .medium
//                            dateFormatter.timeStyle = .none
//                            dateFormatter.locale = Locale(identifier: "en_US")
//                            post["posted_date"] = dateFormatter.string(from: fireTime.dateValue())
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
}




struct SearhView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

