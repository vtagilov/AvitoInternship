//
//  DetailViewModel.swift
//  AvitoInternship
//
//  Created by Владимир on 12.09.2024.
//

import Foundation

final class DetailViewModel {
    
    var resultAction: ((Data) -> Void)?
    var failureAction: ((Error) -> Void)?
    var stopLoadingAction: (() -> ())?
    
    
    private let networkManager = NetworkManager()
    private var downloadImageUrl: String? = nil
    
    func tryMakeRequestsAgain() {
        if let url = downloadImageUrl {
            performImageDataRequest(url)
        }
    }
    
    func performImageDataRequest(_ urlStr: String) {
        networkManager.getImageData(url: urlStr) { result in
            self.stopLoadingAction?()
            switch result {
            case .success(let data):
                self.resultAction?(data)
            case .failure(let error):
                self.failureAction?(error)
                self.downloadImageUrl = urlStr
            }
        }
    }
}
