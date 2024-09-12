//
//  SearchResponse.swift
//  AvitoInternship
//
//  Created by Владимир on 08.09.2024.
//

import Foundation

struct SearchResponse: Decodable {
    let total: Int
    let total_pages: Int
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: SearchUrls
    let description: String?
    let alt_description: String?
    let user: User
    let created_at: String
}

struct SearchUrls: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Decodable {
    let id: String
    let username: String
}
