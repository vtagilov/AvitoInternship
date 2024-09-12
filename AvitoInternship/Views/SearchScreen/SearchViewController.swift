//
//  SearchViewController.swift
//  AvitoInternship
//
//  Created by Владимир on 07.09.2024.
//

import UIKit

final class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    private let searchField = SearchField()
    private let collectionView = SearchCollection()
    private let errorView = ErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
        configureSearchView()
        configureErrorView()
    }
    
    private func configureViewModel() {
        viewModel.loadingAction = { isLoading in
            DispatchQueue.main.async {
                self.searchField.setLoadingStatus(isLoading)
            }
        }
        viewModel.searchErrorAction = { error in
            DispatchQueue.main.async {
                self.errorView.isHidden = false
                print("ERROR: ", error)
            }
        }
        viewModel.searchResultAction = { model in
            DispatchQueue.main.async {
                self.collectionView.models.append(model)
                self.collectionView.reloadData()
            }
        }
    }
    
    private func configureSearchView() {
        searchField.searchAction = { query in
            self.viewModel.suggester.addQuery(query)
            self.viewModel.performSearchRequest(query: query)
            self.collectionView.models = []
        }
        searchField.cellTypeAction = {
            self.collectionView.type = self.collectionView.type == .list ? .table : .list
            self.collectionView.reloadData()
        }
        searchField.sortButtonAction = { type in
            self.viewModel.sortType = type
        }
        searchField.queryWasModified = { text in
            let suggests = self.viewModel.suggester.getSuggests(text)
            self.searchField.setSuggests(suggests)
        }
    }
    
    private func configureErrorView() {
        errorView.tryAgainAction = {
            self.viewModel.tryMakeRequestsAgain()
        }
    }
    
    private func configureView() {
        for subview in [collectionView, searchField, errorView] {
            view.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.75),
            errorView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
        ])
    }
}

