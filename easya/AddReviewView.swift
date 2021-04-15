//
//  AddReviewView.swift
//  easya
//
//  Created by Luciano Handal on 4/5/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AddReviewView: View {
    @State private var course = ""
    @State private var professor = ""
    @State private var placeholder = "Here. Rant"
    @State private var text = "Here. Rant"
    @State private var selectedGrade = "Grade"
    @State private var selectedSemester = "Semester"
    @State private var year = NumbersOnly()
    @State private var rating = 0
    @State private var last_found = ""
    @State var fillStars = [false, false, false, false, false]
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertText = ""
    @State private var allowSubmit = false
    
    let grades = ["None",
                     "A+", "A", "A-",
                     "B+", "B", "B-",
                     "C+", "C", "C-",
                     "D+", "D", "D-",
                     "F"]
    
    let semesters = ["None", "Spring", "Fall", "Summer"]
    
    
    var body: some View {
        
        
        ScrollView(.vertical){
            VStack(alignment: .leading){
                HStack{
                    TextField("Course", text: $course)
                        .onChange(of: course) {_ in
                            validateReview()
                        }
                    Button(action: {
                        last_found = courseAutoComplete(course: course)
                        course = last_found
                        validateReview()
                    }) {
                        Text("Find Course")
                    }
                    
                    
                }.padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertText) , dismissButton: .default(Text("Ok")))
                }
                
                TextField("Professor", text: $professor)
                    .onChange(of: professor) {_ in
                        validateReview()
                    }
                    .padding()
                Picker(selection: $selectedGrade, label: Text(selectedGrade), content: {
                    ForEach(grades, id: \.self) {
                        Text($0)
                    }

                })
                .frame(width: 100, alignment: .leading)
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                HStack(alignment: .center){
                    Picker(selectedSemester, selection: $selectedSemester) {
                        ForEach(semesters, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    TextField("Year", text: $year.value)
                        .keyboardType(.decimalPad)
                    
                }.padding()
                
                TextEditor(text: $text)
                    .foregroundColor(self.text == placeholder ? .gray : .primary)
                    .onTapGesture {
                        if self.text == placeholder {
                            self.text = ""
                        }
                    }
                    .frame(minWidth: 0, minHeight: 0)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                HStack{
                    Spacer()
                    ForEach((0...4), id: \.self){ i in
                        Button(action: {addRating(r: i)}){
                            Image(systemName: fillStars[i] ? "star.fill" : "star")
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack{
                    Spacer()
                    Button(action: {submitReview()}) {
                        Text("Add Review")
                    }.disabled(!allowSubmit)
                    Spacer()
                }.padding()
                
            }
        }
    }
    func addRating(r: Int){
        rating = r + 1
        for i in (0...r) {
            fillStars[i] = true
        }
        validateReview()
        if r == 4 {
            return
        }
        for i in ((r+1)...4) {
            fillStars[i] = false
        }
    }
    
    func validateReview(){
        allowSubmit = course == last_found && professor != "" && rating != 0
    }
    
    func resetFields(){
        course = ""
        professor = ""
        text = placeholder
        selectedGrade = "Grade"
        selectedSemester = "Semester"
        year = NumbersOnly()
        rating = 0
        last_found = ""
        fillStars = [false, false, false, false, false]
        allowSubmit = false
    }
    
    func submitReview(){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(LoginState.username!)
        let courseRef = db.collection("courses").document(course)
        let timestamp = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        var reviewDict: [String: Any] = [
            "author": userRef,
            "course": courseRef,
            "course_id": course,
            "professor": professor,
            "posted_date": timestamp,
            "display_date": dateFormatter.string(from: timestamp),
            "report_count": 0,
            "downvotes": 0,
            "upvotes": 0,
            "text": "",
            "tags": "",
            "rating": rating]
       
        if selectedGrade != "Grade" {
            reviewDict["grade"] = selectedGrade
            
        }
        if selectedSemester != "Semester" {
            reviewDict["semester_taken"] = selectedSemester
        }
        
        if year.value != "" {
            reviewDict["semester_taken_year"] = year.value
        }
        
        if text != placeholder {
            reviewDict["text"] = text
        }
        
        let postCollection = db.collection("posts")
        
       postCollection
            .whereField("author", isEqualTo: userRef)
            .whereField("course", isEqualTo: courseRef)
        .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if (querySnapshot!.documents.count == 0){
                        let postRef = postCollection.addDocument(data: reviewDict) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        if (LoginState.userposts == nil){
                            LoginState.userposts = [String]()
                        }
                        LoginState.userposts?.append(postRef.documentID as String)
                        print(postRef.documentID)
                    } else {
                        exisitingReviewAlert()
                    }
                }
        }
        resetFields()
    }
    
    func exisitingReviewAlert(){
        alertTitle = "Existing review"
        alertText = "You have already reviewed this class. You can delete your old review if you want to write a new one"
        showAlert = true
    }
    
}


class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}

struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AddReviewView()
    }
}
