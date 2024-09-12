//
//  SearchViewModel.swift
//  AvitoInternship
//
//  Created by Владимир on 11.09.2024.
//

import Foundation

final class SearchViewModel {
    enum SortType: String {
        case popular = "relevant"
        case newest = "lastest"
    }
    var sortType: SortType = .popular {
        didSet {
            if sortType != oldValue {
                if let query = lastSearchRequest {
                    performSearchRequest(query: query)
                }
            }
        }
    }
    
    var models = [SearchModel]()
    
    var searchErrorAction: ((Error) -> ())?
    var searchResultAction: ((SearchModel) -> ())?
    var loadingAction: ((Bool) -> ())?
    
    private var isLoading: Bool = false {
        didSet {
            if isLoading && !oldValue { loadingAction?(true) }
            if !isLoading && oldValue { loadingAction?(false) }
        }
    }
    
    private let networkManager = NetworkManager()
    let suggester = SearchSuggester()
    
    private var failureSearchRequest: String? = nil
    private var failureImageDataRequests: [SearchResult] = []
    private var lastSearchRequest: String? = nil
    
    func performSearchRequest(query: String) {
        lastSearchRequest = query
        isLoading = true
        networkManager.searchPhotos(query: query, sorted: sortType) { result in
            self.isLoading = false
            switch result {
            case .success(let response):
                for result in response.results {
                    self.performImageDataRequest(model: result)
                }
            case .failure(let error):
                self.searchErrorAction?(error)
                self.failureSearchRequest = query
            }
            self.failureImageDataRequests = []
        }
    }
    
    func tryMakeRequestsAgain () {
        if let query = failureSearchRequest {
            performSearchRequest(query: query)
        }
    }
    
    private func performImageDataRequest(model: SearchResult) {
        isLoading = true
        networkManager.getImageData(url: model.urls.regular) { result in
            self.isLoading = false
            switch result {
            case .success(let data):
                let description = model.description ?? (model.alt_description ?? "")
                let createdDate = DateFormatter().convertToReadableFormat(isoDate: model.updated_at) ?? model.updated_at
                let unixDate = DateFormatter().convertDateStringToInt(isoDate: model.updated_at) ?? 0
                let model = SearchModel(id: model.id, imageData: data, description: description, username: model.user.username, fullImageUrl: model.urls.full, createdDate: createdDate, unixDate: unixDate)
                self.searchResultAction?(model)
            case .failure(let error):
                self.searchErrorAction?(error)
                self.failureImageDataRequests.append(model)
            }
        }
    }
}
