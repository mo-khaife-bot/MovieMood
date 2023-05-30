//
//  DetailsView.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 30/05/2023.
//

import SwiftUI
import Firebase

import FirebaseFirestoreSwift

struct DetailsView: View {
    
    let movieItem: MovieItem
    
    @EnvironmentObject var authVM: AuthViewModel
    
    
    var body: some View {
        Text(movieItem.title)
        Text(movieItem.overview)
        Text(String(movieItem.id)) // Convert the Int to a String
        Button(action: addToFavorites) {
            Text("Add to Favs")
        }
    }
    
    
    func addToFavorites() {
        guard let user = authVM.currentUser else { return }
        
        let firestore = Firestore.firestore()
        let favoritesCollection = firestore.collection("users").document(user.id).collection("Favourites")
        
        // Convert the movie's ID to a string
        let movieID = String(movieItem.id)
        
        // Create a document using the movie's ID as the document ID
        favoritesCollection.document(movieID).setData([
            "title": movieItem.title,
            "id": movieID,
//            "photo": movieItem.backdropURL ?? "No Data",
            "overview": movieItem.overview,
            // Add any other necessary movie details
        ]) { error in
            if let error = error {
                print("Error adding movie to favorites: \(error.localizedDescription)")
            } else {
                print("Movie added to favorites")
            }
        }
    }
    
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView(movieItem: <#MovieItem#>)
//    }
//}
