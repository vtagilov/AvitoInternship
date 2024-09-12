//
//  SearchViewModel.swift
//  AvitoInternship
//
//  Created by Владимир on 11.09.2024.
//

import Foundation

final class SearchViewModel {
    enum SortType {
        case popular, newest
    }
    var sortType: SortType = .popular
    
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
    
    func performSearchRequest(query: String) {
        isLoading = true
        networkManager.searchPhotos(query: query) { result in
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
                    let model = SearchModel(id: model.id, imageData: data, description: model.description ?? "")
                    self.searchResultAction?(model)
                case .failure(let error):
                    self.searchErrorAction?(error)
                    self.failureImageDataRequests.append(model)
                }
        }
    }
}
