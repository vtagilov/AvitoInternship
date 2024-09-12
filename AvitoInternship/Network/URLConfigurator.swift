//
//  URLConfigurator.swift
//  AvitoInternship
//
//  Created by Владимир on 08.09.2024.
//

import Foundation

final class URLConfigurator {
    enum URLType {
        case searchImage
    }
    
    enum Parameters: String {
        case query
        case apiKey = "client_id"
        case sortType = "order_by"
        case perPage = "per_page"
    }
    
    func configureURL(type: URLType, params: [Parameters: String]) -> URL? {
        var urlString = URLString.configure(type)
        params.forEach { urlString.append("\($0.key.rawValue)=\($0.value)&") }
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        return URL(string: String(urlString))
    }
}

extension URLConfigurator {
    private enum URLString {
        static let base = "https://api.unsplash.com"
        static let searchImage = "\(base)/search/photos?"
        
        static func configure(_ type: URLType) -> String {
            switch type {
            case .searchImage:
                URLConfigurator.URLString.searchImage
            }
        }
    }
}

