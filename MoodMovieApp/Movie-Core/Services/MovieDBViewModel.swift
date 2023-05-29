//
//  MovieDBViewModel.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import Foundation

@MainActor
class MovieDBViewModel: ObservableObject {
    
    @Published var trending: [TrendingItem] = []
    
    let baseAPI = "https://api.themoviedb.org/3"
    
    func getAPIKey() -> String? {
        //        if let path = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist"),
        //           let dict = NSDictionary(contentsOfFile: path),
        //           let apiKey = dict["API_KEY"] as? String {
        //            return apiKey
        //        }
        //        return nil
        guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'TMDB-Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
        }
        return value
    }
    
    func loadTrending() {
        
        Task.detached(priority: .userInitiated) { [self] in
            if let apiKey = await getAPIKey() {
                let urlString = URL(string: "\(baseAPI)/trending/movie/day?api_key=\(apiKey)")!
                
                do {
                    let (data, _) = try await URLSession.shared.data(from: urlString)
                    let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
                    
                    await MainActor.run {
                        self.trending = trendingResults.results
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("Unable to retrieve API key.")
            }
        }
    }
    
}
