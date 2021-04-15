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
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                AddReviewView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                UserView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                    }
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
