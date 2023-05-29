//
//  MovieData.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import Foundation


struct MovieResponse: Decodable {
    
    let results: [Movie]
}


struct Movie: Decodable, Identifiable, Hashable {
    
    let id: Int
    let title : String
    let backdropPath : String?
    let posterPath: String?
    let overview : String
    let voteAverage : Double
    let voteCount : Int
    let runTime : Int?
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func ==(lhs: Movie, rhs: Movie) -> Bool {
            return lhs.id == rhs.id
        }
}
