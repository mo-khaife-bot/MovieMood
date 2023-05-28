//
//  User.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    var favorites: [FavoriteFilm]? = []
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

struct FavoriteFilm: Identifiable, Codable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runTime: Int?
    // Add any other properties related to the film
}
