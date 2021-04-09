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
    
    @State private var allowSubmit = false
    
    let strengths = ["None",
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
                
                TextField("Professor", text: $professor)
                    .onChange(of: professor) {_ in
                        validateReview()
                    }
                    .padding()
                
                Picker(selectedGrade, selection: $selectedGrade) {
                    ForEach(strengths, id: \.self) {
                        Text($0)
                    }
                }
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
    
    func submitReview(){
        var reviewDict: [String: Any] = [
            "username": LoginState.username!,
            "group": LoginState.group!,
            "course_id": course,
            "professor": professor,
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
    
        print(reviewDict)
        print(addReview(course: course, review: reviewDict))
        
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
