//
//  ContentView.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                if authViewModel.userSession != nil {
                    TabView {
                        MainMovieView()
                            .tabItem{
                                Image(systemName: "popcorn")
                                Text("Movies")
                            }
                        
                        
                        ProfileView()
                            .tabItem{
                                Image(systemName: "person.crop.circle.fill")
                                Text("Profile")
                            }
                        
                        
                    }
                    
                } else {
                    LoginView()
                }
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthViewModel()) // Provide an instance of AuthViewModel as an environment object
    }
}
