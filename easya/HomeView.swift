//
//  HomeView.swift
//  easya
//
//  Created by Luciano Handal on 4/2/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var tabSelection = 1
    @State private var current_course = ""
    
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection){
                SearchView(tabSelection: $tabSelection, current_course: $current_course)
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                    .tag(1)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                AddReviewView(tabSelection: $tabSelection, current_course: $current_course)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                    }
                    .tag(2)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                UserView(tabSelection: $tabSelection, current_course: $current_course)
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                    }
                    .tag(3)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
