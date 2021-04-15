//
//  ReviewView.swift
//  easya
//
//  Created by Luciano Handal on 4/14/21.
//

import SwiftUI

struct Review {
    var author: String
    var grade: String
    var professor: String
    var text: String
    var semester: String
    var date: String
    var id: String
    var course_id: String
    var professor_link: URL
    var upvotes: Int
    var downvotes: Int
    var rating: Int
    var report_count: Int
    var upvote: Bool
    var downvote: Bool
    var delete: Bool
    var userScreen: Bool
    
    init(post: [String:Any]) {
        self.author = post["author"] as! String
        self.grade = post["grade"] as! String
        self.professor = post["professor"] as! String
        self.text = post["text"] as! String
        self.semester = post["semester_taken"] as! String
        self.date = post["display_date"] as! String
        self.id = post["post_ID"] as! String
        self.course_id = post["course_id"] as! String
        self.upvotes = post["upvotes"] as! Int
        self.downvotes = post["downvotes"] as! Int
        self.rating = post["rating"] as! Int
        self.report_count = post["report_count"] as! Int
        self.upvote = post["upvote"] as! Bool
        self.downvote = post["downvote"] as! Bool
        self.delete = post["delete"] as! Bool
        self.userScreen = post["userScreen"] as! Bool
        
        self.professor_link  = URL(string: post["professor_link"] as! String) ?? URL(string: "https://www.ratemyprofessors.com")!
        
        
    }
}


struct ReviewCell: View {
    @State var review: Review
    @State var visible: Bool = true
    
    var body: some View {
        if (visible){
            VStack(){
                VStack(alignment: .leading){
                    if (review.delete) {
                        HStack{
                            if (review.userScreen){
                                Text(review.course_id).fontWeight(.bold)
                            } else {
                                Text("Your review").fontWeight(.bold)
                            }
                            Spacer()
                            Button(action: {
                                deleteReview(reviewId: review.id)
                                visible = false
                                
                            }) {
                                Text("Delete")
                            }
                        }.padding(.vertical)
                    }
                    HStack{
                        VStack(alignment: .leading){
                            Text("Professor:")
                                .font(.caption)
                            Text(review.professor)
                        }.padding(.vertical, 2.0).padding(.horizontal)
                        Spacer()
                        Text(review.date)
                            .font(.caption)
                            .multilineTextAlignment(.trailing)
                        
                    }
                    if (review.grade != ""){
                        VStack(alignment: .leading){
                            Text("Grade:").font(.caption)
                            Text(review.grade)
                        }.padding(.vertical, 2.0).padding(.horizontal)
                        
                    }
                    if (review.semester != ""){
                        VStack(alignment: .leading){
                            Text("Semester:").font(.caption)
                            Text(review.semester)
                        }.padding(.vertical, 2.0).padding(.horizontal)
                        
                    }
                    
                    if (review.text != ""){
                        Text(review.text).padding()
                    }
                    
                    
                    HStack{
                        Button(action: {
                            upvoteReview(review: review)
                            if (review.upvote){ // already upvoted
                                review.upvotes -= 1
                            } else {// new like
                                review.upvotes += 1
                                if (review.downvote){// downvoted before
                                    review.downvotes -= 1
                                    review.downvote = false
                                }
                            }
                            review.upvote = !review.upvote
                            
                            
                        }) {
                            Text("\(review.upvotes)")
                            Image(systemName: review.upvote ? "hand.thumbsup.fill" : "hand.thumbsup")
                        }
                        Button(action: {
                            downvoteReview(review: review)
                            if (review.downvote){ // already downvoted
                                review.downvotes -= 1
                            } else { // new downvote
                                review.downvotes += 1
                                
                                if (review.upvote){ // upvoted before
                                    review.upvotes -= 1
                                    review.upvote = false
                                }
                            }
                            review.downvote = !review.downvote
                        }) {
                            Text("\(review.downvotes)")
                            Image(systemName: review.downvote ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        }.padding(.horizontal)
                        Spacer()
                        HStack{
                            ForEach((1...review.rating), id: \.self){ _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color("AccentColor"))
                            }
                            if (review.rating < 5){
                                ForEach((1...(5 - review.rating)), id: \.self){ _ in
                                    Image(systemName: "star")
                                        .foregroundColor(Color("AccentColor"))
                                }
                            }
                            
                        }
                    }
                }
                .padding(.all)
                .background(Color("BackgroundColor"))
                .cornerRadius(16)
            }
        }
    }
}




//
//struct SearhView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
