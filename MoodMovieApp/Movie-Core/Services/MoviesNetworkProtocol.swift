//
//  NetworkableProtocol.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import Foundation

protocol MoviesNetworkProtocol {
    //    func fetchTrendingMovies(from url: URL, completion: @escaping (Result<TrendingResults, MovieError>) -> ())
    
    //    func fetchTrendingMovies(apiKey: String, completion: @escaping (Result<TrendingResults, MovieError>) -> ())
    //    func searchMovies(query: String, completion: @escaping (Result<TrendingResults, MovieError>) -> ())
    
    func fetchTrendingMovies(completion: @escaping (Result<MovieResults, MovieError>) -> ())
    func searchMovies(query: String, completion: @escaping (Result<MovieResults, MovieError>) -> ())
}
