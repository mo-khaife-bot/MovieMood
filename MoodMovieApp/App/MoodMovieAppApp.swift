//
//  MoodMovieAppApp.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import SwiftUI
import Firebase

@main
struct MoodMovieAppApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authViewModel)
        }
    }
}
