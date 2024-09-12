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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
        configureSearchView()
    }
    
    private func configureViewModel() {
        viewModel.loadingAction = { isLoading in
            DispatchQueue.main.async {
                self.searchField.setLoadingStatus(isLoading)
            }
        }
        viewModel.searchErrorAction = { error in
            DispatchQueue.main.async {
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
    }
    
    private func configureView() {
        for subview in [searchField, collectionView] {
            view.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 35),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

