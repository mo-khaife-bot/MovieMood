//
//  MovieError.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import Foundation

enum MovieError: Error {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self{
            
        case .apiError:
            return "Failed to fetch data"
        case .invalidEndpoint:
            return "Invalid endpoint"
            
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "no data"
        case .serializationError:
            return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
