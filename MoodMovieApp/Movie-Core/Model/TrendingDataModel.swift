//
//  TrendingDataModel.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import Foundation

struct MovieResults: Decodable {
    let page: Int
    let results: [MovieItem]
    let total_pages: Int
    let total_results: Int
}

struct MovieItem: Identifiable, Decodable{
    let adult: Bool
    let id: Int
    let poster_path: String?
    let title: String
    let vote_average: Float
    let backdrop_path: String?
    let overview : String
    //    let runTime : Int?
    let release_date : String
    
    var backdropURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w300")!
        return baseURL.appending(path: backdrop_path ?? "")
    }
    
    var postThumbnail: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w100")!
        return baseURL.appending(path: poster_path ?? "")
    }
    
    
    var releaseYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: release_date) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return String(year)
        }
        
        return ""
    }
}
