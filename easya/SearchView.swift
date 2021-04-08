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
    var professor_link: URL
    var upvotes: Int
    var downvotes: Int
    var rating: Int
    var report_count: Int
    
    init(author: String, grade: String, professor: String, text: String, semester: String, date: String, professor_link: String, upvotes: Int, downvotes: Int, rating: Int, report_count: Int) {
        
        self.author = author
        self.grade = grade
        self.professor = professor
        self.text = text
        self.semester = semester
        self.date = date
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.rating = rating
        self.report_count = report_count
        
        
        self.professor_link  = URL(string: professor_link)!
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
                                        Text("\(reviews[i].upvotes)")
                                        Text("\(reviews[i].downvotes)")
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
                       "professor_link"]
        
        let intKeys = ["upvotes",
                       "downvotes",
                       "professor",
                       "rating",
                       "report_count"]
        
        for key in strKeys{
            if (p[key] == nil) {
                p[key] = ""
            }
        }
        for key in intKeys{
            if (p[key] == nil) {
                p[key] = 0
            }
        }
        return p
    }
    
    func getPosts(){
        for p in posts{
            let post = sanitizePost(post: p)
            print(post)
            
            let rev = Review(author: post["author"] as! String,
                             grade: post["grade"] as! String,
                             professor: post["professor"] as! String,
                             text: post["text"] as! String,
                             semester: post["semester_taken"] as! String,
                             date: post["display_date"] as! String,
                             professor_link: post["professor_link"] as! String,
                             upvotes: post["upvotes"] as! Int,
                             downvotes: post["downvotes"] as! Int
                             ,
                             rating: post["rating"] as! Int,
                             report_count: post["report_count"] as! Int)
            reviews.append(rev)
        }
    }
}



struct SearhView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

