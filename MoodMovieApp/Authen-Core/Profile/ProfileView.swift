//
//  ProfileView.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import SwiftUI

import Firebase

import FirebaseFirestoreSwift

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showLoginView = false // Flag to control navigation to LoginView
    @State private var favoriteFilms: [FavoriteFilm] = []
    
    //    struct FavoriteFilm: Identifiable  {
    ////        var id: ObjectIdentifier
    //
    //        let id = Int
    //        let title: String
    //        let overview: String
    //
    //        init(id: String, title: String, overview: String) {
    //            self.title = title
    //            self.overview = overview
    //        }
    //    }
    
    struct FavoriteFilm: Identifiable {
        let id: String
        let title: String
        let overview: String
        // Add any additional film details you want to fetch
        
        // Update the initializer to include the additional film details
        init(id: String, title: String, overview: String) {
            self.id = id
            self.title = title
            self.overview = overview
        }
    }
    
    var body: some View {
        if let user = authVM.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                if favoriteFilms.count > 0 {
                    Section(header: Text("Favorite Films")) {
                        ForEach(favoriteFilms) { film in
                            HStack {
                                Text(String(film.title.prefix(32)) + (film.title.count > 32 ? "..." : ""))
                                Spacer()
                                Button(action: {
                                    deleteFavoriteFilm(film)
                                }, label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                })
                            }
                            // Display other film details
                        }
                    }
                }
                
                Section("Account") {
                    Button {
                        authVM.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                }
            }
            .navigationBarTitle("Profile")
            .background(
                NavigationLink(destination: LoginView(), isActive: $showLoginView) {
                    EmptyView()
                }
                    .hidden()
            )
            .onAppear(perform: fetchFavorites) // Fetch favorite films on view appear
        }
    }
    
    //    func fetchFavorites() {
    //        guard let user = authVM.currentUser else { return }
    //
    //        let firestore = Firestore.firestore()
    //        let favoritesCollection = firestore.collection("users").document(user.id).collection("Favourites")
    //
    //        favoritesCollection.getDocuments { snapshot, error in
    //            if let error = error {
    //                print("Error fetching favorite films: \(error.localizedDescription)")
    //            } else {
    //                guard let documents = snapshot?.documents else { return }
    //
    //                let dispatchGroup = DispatchGroup()
    //                var films: [FavoriteFilm] = []
    //
    //                for document in documents {
    //                    let data = document.data()
    //
    //                    guard let title = data["title"] as? String,
    //                          let overview = data["overview"] as? String,
    //                          let filmID = data["id"] as? String
    //                    else {
    //                        continue
    //                    }
    //
    //                    dispatchGroup.enter()
    //
    //                    // Fetch additional film details using the filmID
    //                    let filmDocument = firestore.collection("films").document(filmID)
    //                    filmDocument.getDocument { filmDocumentSnapshot, filmError in
    //                        if let filmError = filmError {
    //                            print("Error fetching film details for \(filmID): \(filmError.localizedDescription)")
    //                        } else if let filmData = filmDocumentSnapshot?.data() {
    //                            // Extract additional film details from the filmData
    //                            // For example, let's assume there is a field called "director"
    //                            if let director = filmData["director"] as? String {
    //                                // Create the FavoriteFilm object with all details
    //                                let favoriteFilm = FavoriteFilm(id: filmID, title: title, overview: overview)
    //                                films.append(favoriteFilm)
    //                            }
    //                        }
    //
    //                        dispatchGroup.leave()
    //                    }
    //                }
    //
    //                dispatchGroup.notify(queue: .main) {
    //                    self.favoriteFilms = films
    //                }
    //            }
    //        }
    //    }
    
    func fetchFavorites() {
        guard let user = authVM.currentUser else { return }
        
        let firestore = Firestore.firestore()
        let favoritesCollection = firestore.collection("users").document(user.id).collection("Favourites")
        
        
        favoritesCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching favorite films: \(error.localizedDescription)")
            } else {
                guard let documents = snapshot?.documents else { return }
                
                let dispatchGroup = DispatchGroup()
                var films: [FavoriteFilm] = []
                
                for document in documents {
                    let data = document.data()
                    
                    guard let title = data["title"] as? String,
                          let overview = data["overview"] as? String,
                          let filmID = data["id"] as? String
                    else {
                        continue
                    }
                    
                    dispatchGroup.enter()
                    
                    // Fetch additional film details using the filmID if necessary
                    // ...
                    
                    let favoriteFilm = FavoriteFilm(id: filmID, title: title, overview: overview)
                    films.append(favoriteFilm)
                    
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.favoriteFilms = films
                }
            }
        }
    }
    
    
    
    func deleteFavoriteFilm(_ film: FavoriteFilm) {
        guard let user = authVM.currentUser else { return }
        
        let firestore = Firestore.firestore()
        let favoritesCollection = firestore.collection("users").document(user.id).collection("Favourites")
        let filmDocument = favoritesCollection.document(film.id)
        
        filmDocument.delete { error in
            if let error = error {
                print("Error deleting favorite film: \(error.localizedDescription)")
            } else {
                print("Favorite film deleted")
                
                
                // Refresh the favorite films list
                fetchFavorites()
            }
        }
    }
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel()) // Provide an instance of AuthViewModel
    }
}
