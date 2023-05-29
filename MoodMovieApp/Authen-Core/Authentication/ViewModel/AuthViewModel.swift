//
//  AuthViewModel.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import Foundation

import Foundation
import Firebase

import FirebaseFirestoreSwift


protocol AuthenticationFormProtocol {
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    //represents the current authenticated user, obtained from Firebase Authentication, helps navigate to profile screen
    // marked as @Published, which means any changes to it will automatically update the subscribed views.
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User? // represents additional information about the user
    
    
    
    //initializes the AuthViewModel by setting the "userSession" property to the current user obtained from Firebase Authentication
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
        
    }
    
    
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
            // have to AWAIT for Sign in details for User to be linked to userSession
            //then fetch the user document corresponding to user's UID from the Firestore "users" collection.
            // then attempts to parse the data from the retrieved document into a User object and assigns it to the currentUser property
            await fetchUser()
            
        } catch{
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            
        }
        
        
    }
    
    
    
    
    //creates a new user account with the provided email, password, and full name.
    //It uses Firebase Authentication to create the user, updates the "userSession" property, and stores additional user information in Firestore.
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
//            let user = User(id: result.user.uid, fullName: fullname, email: email)
            let user = User(id: result.user.uid, fullName: fullname, email: email, favorites: [])
            
            
            // Codable User struct gains the ability to be easily encoded (serialized) to a data representation i.e JSON data to upload to Firebase
            // useful when you need to send or receive user data in a structured format, i.e  storing/retrieving data from a database.
            let encodedUser = try Firestore.Encoder().encode(user)
            
            //once encoded users data upload then uploaded to the "users" collection in Firestore.
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            // have to AWAIT to fetch the newly created user data we just uploaded to Firebase to dispaly on the screen
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
        
    }
    
    
    
    
    // signs the user out back to login on Client side
    // on backend logs out of Firebase
    func signOut() {
        do{
            try Auth.auth().signOut() // sign out user on backend
            self.userSession = nil // wipes out user session and takes us back to login screen
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        
    }
    
    
    
    /*
     func deleteAccount() {
     guard let user = Auth.auth().currentUser else {
     return
     }
     
     // Re-authenticate the user
     let credential = EmailAuthProvider.credential(withEmail: user.email ?? "name@example.com", password: "<user-password>")
     user.reauthenticate(with: credential) { [weak self] authResult, error in
     if let error = error {
     print("DEBUG: Failed to re-authenticate user with error \(error.localizedDescription)")
     return
     }
     
     // Delete user document from Firestore
     let uid = user.uid
     Firestore.firestore().collection("users").document(uid).delete { [weak self] error in
     if let error = error {
     print("DEBUG: Failed to delete user document with error \(error.localizedDescription)")
     return
     }
     
     // Delete user account from Firebase Authentication
     user.delete { [weak self] error in
     if let error = error {
     print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
     } else {
     self?.userSession = nil
     self?.currentUser = nil
     print("Account deleted successfully")
     }
     }
     }
     }
     
     }
     */
    
    var userFavoritesCollection: CollectionReference? {
        // returns the reference to the "favorites" subcollection within the user's document in Firestore
        guard let userId = currentUser?.id else {
            return nil
        }
        return Firestore.firestore().collection("users").document(userId).collection("favorites")
    }
    
    /**
     retrieves the user document corresponding to the currently authenticated user's UID from the Firestore "users" collection.
     It then attempts to parse the data from the retrieved document into a User object and assigns it to the currentUser property.
     
     A DocumentSnapshot object is a representation of a document within a Firestore database.
     It contains the data of a specific document and provides methods to access that data.
     You can retrieve field values using subscript syntax or by calling specific methods like get() or data() on the snapshot.
     Additionally, the DocumentSnapshot allows you to check if a field exists in the document using the contains() method.
     */
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // It uses the UID to fetch the document
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        
        // Attempts to parse the data from the retrieved document into a User object using the snapshot.data(as: User.self) method and assigns it to the currentUser property
        self.currentUser = try? snapshot.data(as: User.self)
        
        // Fetch user's favorite films from "favorites" subcollection
        if let favoritesCollection = userFavoritesCollection {
            // if it exists the function fetches the documents within that collection, which represent the user's favorite films
            let querySnapshot = try? await favoritesCollection.getDocuments()
            
            // then maps each document to a FavoriteFilm object and assigns the resulting array to the favorites property of the currentUser
            let favoriteFilms = querySnapshot?.documents.compactMap { document -> FavoriteFilm? in
                return try? document.data(as: FavoriteFilm.self)
            }
            self.currentUser?.favorites = favoriteFilms
        }
        
        
        
    }
    
    
}
