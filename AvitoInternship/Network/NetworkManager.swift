//
//  NetworkManager.swift
//  AvitoInternship
//
//  Created by Владимир on 08.09.2024.
//

import Foundation

final class NetworkManager {
    private let apiKey = "uto1-74hCCO8kpWghtfdI8flQQheqzxM3hLEu19D44M"
    
    func searchPhotos(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let url = URLConfigurator().configureURL(
            type: .searchImage,
            params: [
                .query: query,
                .apiKey: apiKey
            ]) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.dataEmpty))
                return
            }
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                completion(.success(searchResponse))
            } catch {
                completion(.failure(NetworkError.decodeError))
            }
        }.resume()
    }
    
    func getImageData(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.dataEmpty))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
