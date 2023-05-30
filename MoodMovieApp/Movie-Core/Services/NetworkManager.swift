//
//  NetworkManager.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import Foundation

class NetworkManager: MoviesNetworkProtocol {
    
    let baseAPI = "https://api.themoviedb.org/3"
    
    func getAPIKey() -> String? {
        
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
    
    //    func fetchTrendingMovies(from url: URL, completion: @escaping (Result<TrendingResults, MovieError>) -> ()) {
    //        URLSession.shared.dataTask(with: url) { data, _, error in
    //            if error != nil {
    //                completion(.failure(.apiError))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completion(.failure(.noData))
    //                return
    //            }
    //
    //            do {
    //                let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
    //                completion(.success(trendingResults))
    //            } catch {
    //                completion(.failure(.serializationError))
    //            }
    //        }.resume()
    //    }
    
    func fetchTrendingMovies(completion: @escaping (Result<MovieResults, MovieError>) -> ()) {
        guard let apiKey = getAPIKey() else {
            fatalError("Unable to retrieve API key.")
        }
        
        
        let urlString = "\(baseAPI)/trending/movie/day?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        fetchMovies(from: url, completion: completion)
    }
    
    
    
    func searchMovies(query: String, completion: @escaping (Result<MovieResults, MovieError>) -> ()) {
        guard let apiKey = getAPIKey() else {
            completion(.failure(.apiError))
            return
        }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseAPI)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&page=1&include_adult=false"
//            .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        fetchMovies(from: url) { result in
            switch result {
            case .success(let movieResults):
                completion(.success(movieResults))
            case .failure(let error):
                print("Error fetching movies:", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    // Private helper method for fetching movies from a given URL
    private func fetchMovies(from url: URL, completion: @escaping (Result<MovieResults, MovieError>) -> ()) {
        // Implementation to fetch movies using URLSession
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResults.self, from: data)
                completion(.success(response))
            } catch {
                print("JSON decoding error:", error.localizedDescription)
                completion(.failure(.serializationError))
            }
        }.resume()
    }
}
