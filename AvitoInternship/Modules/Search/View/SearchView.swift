import UIKit

protocol SearchView: View {
    func addProducts(products: [PreviewProduct])
    func setProducts(products: [PreviewProduct])
    func updateState(_ newState: SearchViewController.State)
}

enum ErrorViewType: Error, Equatable {
    case networkError
}

final class SearchViewController: UIViewController, SearchView {
    enum State: Equatable {
        case common
        case loading
        case error(ErrorViewType?)
        case noResults
    }

    var presenter: SearchPresenter!

    private var state: State = .common
    private var collectionView: SearchCollectionView!
    private lazy var searchBar = SearchBar()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var noResultsLabel = UILabel(frame: .zero)
    private lazy var errorView = ErrorView()
    
    override func viewDidLoad() {
        configureView()
        presenter.loadProducts(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func addProducts(products: [PreviewProduct]) {
        collectionView.addItems(products)
        updateState(.common)
    }
    
    func setProducts(products: [PreviewProduct]) {
        collectionView.setItems(products)
        updateState(.common)
    }
    
    func updateState(_ newState: State) {
        if state == newState { return }
        updateState(state: state, isActive: false)
        updateState(state: newState, isActive: true)
        state = newState
    }
    
    private func updateState(state: State, isActive: Bool) {
        let isHidden = !isActive
        switch state {
        case .common:
            collectionView.isHidden = isHidden
        case .loading:
            activityIndicator.isHidden = isHidden
        case .error(let type):
            errorView.isHidden = isHidden
            if let type = type {
                errorView.configure(type: type)
            }
        case .noResults:
            noResultsLabel.isHidden = isHidden
        }
    }
}

extension SearchViewController {
    private func configureCell(model: PreviewProduct, index: Int) {
        let index = IndexPath(row: index, section: 0)
        guard let cell = collectionView.cellForItem(at: index) as? SearchCollectionCell else {
            return
        }
        collectionView.configureCell(cell, with: model, at: index)
    }

    private func configureView() {
        view.backgroundColor = .primaryBackground
        
        searchBar.searchDelegate = self
        
        let itemSize = (view.frame.width / 2.0) - 8 * 2 + 4
        collectionView = SearchCollectionView(itemWidth: itemSize)
        collectionView.searchDelegate = self
        collectionView.isHidden = true
        
        activityIndicator.startAnimating()
        
        errorView.isHidden = true
        
        noResultsLabel.isHidden = true
        noResultsLabel.text = "Ничего не нашлось"
        noResultsLabel.textColor = .contentColor
        
        for subview in [collectionView!, searchBar, activityIndicator, noResultsLabel, errorView] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SearchViewController: SearchCollectionViewDelegate {
    func didSelectItem(item: PreviewProduct) {
        presenter.productSelected(product: item)
    }
    
    func didReachEndOfData() {
        presenter?.loadMoreProducts()
    }
}

extension SearchViewController: SearchBarDelegate {
    func searchButtonClicked(text: String?) {
        presenter?.loadProducts(searchBar.text)
    }
    
    func filterButtonTapped() {
        presenter.filterButtonPressed()
    }
}
