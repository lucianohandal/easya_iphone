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
    
    
    var body: some View {
        NavigationView {
            TabView {
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
//                    .padding(.top, 40.0)
//                    .edgesIgnoringSafeArea(.top)
//                    .background(Color("BackgroundColor").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
                
                AddReviewView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                    }
                    .background(Color("BackgroundColor").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
                
                UserView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                    }
                    .background(Color("BackgroundColor").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
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
