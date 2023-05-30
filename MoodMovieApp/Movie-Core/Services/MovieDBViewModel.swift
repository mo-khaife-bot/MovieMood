//
//  MovieDBViewModel.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import Foundation
//import Combine

////@MainActor
////class MovieDBViewModel: ObservableObject {
////
////    @Published var trendingList: [TrendingItem] = []
////
////    let baseAPI = "https://api.themoviedb.org/3"
////
////    func getAPIKey() -> String? {
////        //        if let path = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist"),
////        //           let dict = NSDictionary(contentsOfFile: path),
////        //           let apiKey = dict["API_KEY"] as? String {
////        //            return apiKey
////        //        }
////        //        return nil
////        guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
////            fatalError("Couldn't find file 'TMDB-Info.plist'.")
////        }
////        // 2
////        let plist = NSDictionary(contentsOfFile: filePath)
////        guard let value = plist?.object(forKey: "API_KEY") as? String else {
////            fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
////        }
////        return value
////    }
////
////    func loadTrending() {
////
////        Task.detached(priority: .userInitiated) { [self] in
////            if let apiKey = await getAPIKey() {
////                let urlString = URL(string: "\(baseAPI)/trending/movie/day?api_key=\(apiKey)")!
////
////                do {
////                    let (data, _) = try await URLSession.shared.data(from: urlString)
////                    let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
////
////                    await MainActor.run {
////                        self.trendingList = trendingResults.results
////                    }
////                } catch {
////                    print(error.localizedDescription)
////                }
////            } else {
////                print("Unable to retrieve API key.")
////            }
////        }
////    }
////
////}
//
//
//class MovieDBViewModel: ObservableObject, MoviesNetworkProtocol {
//
//    static let shared = MovieDBViewModel()
//
//    let baseAPI = "https://api.themoviedb.org/3"
//
//    func getAPIKey() -> String? {
//        //        if let path = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist"),
//        //           let dict = NSDictionary(contentsOfFile: path),
//        //           let apiKey = dict["API_KEY"] as? String {
//        //            return apiKey
//        //        }
//        //        return nil
//        guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
//            fatalError("Couldn't find file 'TMDB-Info.plist'.")
//        }
//        // 2
//        let plist = NSDictionary(contentsOfFile: filePath)
//        guard let value = plist?.object(forKey: "API_KEY") as? String else {
//            fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
//        }
//        return value
//    }
//
//    let urlSession = URLSession.shared
//    let jsonDecoder = Utils.jsonDecoder
//
//    // @Published property to store the TrendingResults
//    @Published var movieResponse: TrendingResults?
//
//    func fetchTrendingMovies(completion: @escaping (Result<TrendingResults, MovieError>) -> ()) {
//        if let apiKey =  getAPIKey() {
//            guard let url = URL(string: "\(baseAPI)/trending/movie/day?api_key=\(apiKey)") else {
//                completion(.failure(.invalidEndpoint))
//                return
//            }
//        }
//
//    }
//
//
//    @Published var trendingList: [TrendingItem] = []
//
//
//
////    func loadTrending() {
////
////        Task.detached(priority: .userInitiated) { [self] in
////            if let apiKey = await getAPIKey() {
////                let urlString = URL(string: "\(baseAPI)/trending/movie/day?api_key=\(apiKey)")!
////
////                do {
////                    let (data, _) = try await URLSession.shared.data(from: urlString)
////                    let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
////
////                    await MainActor.run {
////                        self.trendingList = trendingResults.results
////                    }
////                } catch {
////                    print(error.localizedDescription)
////                }
////            } else {
////                print("Unable to retrieve API key.")
////            }
////        }
////    }
//
//    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
//
//        if let apiKey = getAPIKey() {
//
//            guard var urlComponents =  URLComponents(url: url, resolvingAgainstBaseURL: false) else {
//                completion(.failure(.invalidEndpoint))
//                return
//            }
//
//
//            var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
//            if let params = params {
//                queryItems.append(contentsOf: params.map {URLQueryItem(name: $0.key, value: $0.value) })
//            }
//
//            urlComponents.queryItems = queryItems
//
//            guard let finalURL = urlComponents.url else {
//                completion(.failure(.invalidEndpoint))
//                return
//            }
//
//            urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
//                guard let self = self else {return}
//                if let error = error {
//                    print("Error:", error)
//                    self.excuteCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse, 20..<300 ~= httpResponse.statusCode else {
//                    print("Invalid Response:", response ?? "invalid response returned")
//                    self.excuteCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
//                    return
//                }
//
//                guard let data = data else {
//                    self.excuteCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
//                    return
//                }
//
//                do {
//                    let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
//                    self.excuteCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
//                } catch {
//                    self.excuteCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
//                }
//            }.resume()
//
//        }
//
//    }
//
//
//    private func excuteCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
//        DispatchQueue.main.async {
//            completion(result)
//        }
//
//    }
//
//}

class MovieDBViewModel: ObservableObject {
    
    @Published var moviesList: [MovieItem] = []
    @Published var searchResults: [MovieItem] = []
    
    //    let baseAPI = "https://api.themoviedb.org/3"
    
    let networkManager: MoviesNetworkProtocol
    
    init(networkManager: MoviesNetworkProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    
    //    func getAPIKey() -> String? {
    //
    //        guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
    //            fatalError("Couldn't find file 'TMDB-Info.plist'.")
    //        }
    //        // 2
    //        let plist = NSDictionary(contentsOfFile: filePath)
    //        guard let value = plist?.object(forKey: "API_KEY") as? String else {
    //            fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
    //        }
    //        return value
    //    }
    //
    //
    //
    //
    //    func fetchTrendingMovies() {
    //        guard let apiKey = getAPIKey() else {
    //            fatalError("Unable to retrieve API key.")
    //        }
    //
    //
    //        let urlString = "\(baseAPI)/trending/movie/day?api_key=\(apiKey)"
    //        guard let url = URL(string: urlString) else {
    //            fatalError("Invalid URL: \(urlString)")
    //        }
    //
    //        networkManager.fetchTrendingMovies(from: url) { result in
    //            switch result {
    //            case .success(let trendingResults):
    //                DispatchQueue.main.async {
    //                    self.trendingList = trendingResults.results
    //                }
    //            case .failure(let error):
    //                print("Error: \(error.localizedDescription)")
    //            }
    //        }
    //    }
    
    func fetchTrendingMovies() {
        networkManager.fetchTrendingMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let trendingMovies):
                    self?.moviesList = trendingMovies.results
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    func searchMovies(query: String) {
        networkManager.searchMovies(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchQueryResults):
                    self?.searchResults = searchQueryResults.results
                case .failure(let error):
                    print("Search Movies Error:", error)
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: MovieError) {
        // Handle the error based on its type
        switch error {
        case .apiError:
            // Handle API error
            print("API error occurred: \(error.localizedDescription)")
        case .invalidEndpoint:
            // Handle invalid endpoint error
            print("Invalid endpoint: \(error.localizedDescription)")
        case .invalidResponse:
            // Handle invalid response error
            print("Invalid response: \(error.localizedDescription)")
        case .noData:
            // Handle no data error
            print("No data available: \(error.localizedDescription)")
        case .serializationError:
            // Handle serialization error
            print("Serialization error occurred: \(error.localizedDescription)")
        }
        
    }
    
}
