//
//  NetworkError.swift
//  AvitoInternship
//
//  Created by Владимир on 08.09.2024.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case dataEmpty
    case decodeError
    case invalidResponse
    
    public var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Failed to create a valid URL."
        case .dataEmpty:
            return "Received empty data from the server."
        case .decodeError:
            return "Failed to decode the response data."
        case .invalidResponse:
            return "Unexpected server response received."
        }
    }
}
