//
//  SearchView.swift
//  easya
//
//  Created by Luciano Handal on 4/5/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

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
    @State private var courseFound: Bool = false
    @State private var posts: Array<[String : Any]> = []
    
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
                    getCourseInfo(course_id:courseAutoComplete(course: course))
                    getPosts()
                    
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
    func getCourseInfo(course_id: String){
        var course_dict = getCourseDict(course: course_id)
        
        if (course_dict["posts"] == nil){
            course_dict["posts"] = []
        }
        id = course_dict["id"] as! String
        name = course_dict["name"] as! String
        description = course_dict["description"] as! String
        rating = course_dict["rating"] as! Int
        posts = course_dict["posts"] as! Array<[String : Any]>
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
                       "report_count",
                       "upvote",
                       "downvote"]
        
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
    
    func getPosts(){
        for p in posts{
            let post = sanitizePost(post: p)
            print(post)
            reviews.append(Review(post: post))
        }
    }
    
    func upvoteReview(i: Int){
        if (reviews[i].upvote){
            reviews[i].upvotes -= 1
        } else {
            reviews[i].upvotes += 1
            if (reviews[i].downvote){
                reviews[i].downvotes -= 1
                reviews[i].downvote = false
            }
        }
        reviews[i].upvote = !reviews[i].upvote
        upvotePost(postID: reviews[i].id)
//        print("upvoteReview", reviews[i].id)
    }
    
    func downvoteReview(i: Int){
        if (reviews[i].downvote){
            reviews[i].downvotes -= 1
        } else {
            reviews[i].downvotes += 1
            if (reviews[i].upvote){
                reviews[i].upvotes -= 1
                reviews[i].upvote = false
            }
        }
        reviews[i].downvote = !reviews[i].downvote
        downvotePost(postID: reviews[i].id)
//        print("downvoteReview", reviews[i].id)
    }
}



struct SearhView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

