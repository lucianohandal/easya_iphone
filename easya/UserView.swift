//
//  UserView.swift
//  easya
//
//  Created by Luciano Handal on 4/5/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct UserView: View {
    @State private var logoutSuccess = false
    @State private var careerID = "lhandal"
    @State var reviews : [Review] = []
    
    var body: some View {
        VStack(){
            VStack(alignment: .leading){
                Text(careerID)
                    .font(.title)
                    .padding([.top, .leading, .trailing])
                
                Text("\(reviews.count) reviews")
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .padding([.leading, .bottom, .trailing])
                HStack() {
                    Spacer()
                    NavigationLink(destination: LoginView(), isActive: $logoutSuccess) {
                        Button(action: {
                            resetPassword(email: LoginState.email ?? "")
                            logout()
                            logoutSuccess = true
                        }) {
                            Text("Reset Password")
                        }
                    }.padding()
                    Spacer()
                    NavigationLink(destination: LoginView(), isActive: $logoutSuccess) {
                        Button(action: {
                            logout()
                            logoutSuccess = true
                        }) {
                            Text("Log out")
                        }
                    }.padding()
                    Spacer()
                }
            }
            if (reviews.count == 0){
                Spacer()
                    .frame(height: 500.0)
            } else {
                ScrollView(.vertical){
                    ForEach(0...reviews.count - 1, id: \.self){i in
                        ReviewCell(review: reviews[i]).padding(.vertical)
                    }
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16.0)
        .onAppear {
            let db = Firestore.firestore()
            careerID = LoginState.username ?? ""
            let userRef = db.collection("users").document(careerID)
            
            
            
            db.collection("posts")
                .whereField("author", isEqualTo: userRef)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for postDoc in querySnapshot!.documents {
                            var post: [String: Any] = postDoc.data()
                            post["post_ID"] = postDoc.documentID
                            post["delete"] = true
                            post["userScreen"] = true
                            post["posted_date"] = ""
                            post = sanitizePost(post: post)
                            print(postDoc.documentID)
                            post["upvote"] = LoginState.upvotes?.contains(postDoc.documentID)
                            post["downvote"] = LoginState.downvotes?.contains(postDoc.documentID)
                            
                            print(post)
                            let review = Review(post: post)
                            reviews.append(review)
                        }
                    }
                }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

