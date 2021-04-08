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
    @State private var professor = ""
    @State private var text = "Here. Rant"
    @State private var selectedGrade = "Grade"
    @State private var selectedSemester = "Semester"
    
    let strengths = ["None",
                     "A+", "A", "A-",
                     "B+", "B", "B-",
                     "C+", "C", "C-",
                     "D+", "D", "D-",
                     "F"]
    
    let semesters = ["None", "Spring", "Fall", "Summer"]
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            TextField("Professor", text: $professor)
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
                TextField("Year", text: $professor)
                
            }.padding()
            
            TextEditor(text: $text)
                .frame(minWidth: 0, minHeight: 0)
                .multilineTextAlignment(.leading)
                .padding()
            
            Button(action: {
                print("1")
            }) {
                Image(systemName: "star")
            }
            
            
        }.background(Color("BackgroundColor").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        
    }
    
    
}

struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AddReviewView()
    }
}
