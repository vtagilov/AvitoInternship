import UIKit

protocol SearchView: View {
    func showError(type: ErrorViewType)
    func configureCell(model: PreviewProduct, index: Int)
    func showCategories(categories: [Category])
    func addProducts(products: [PreviewProduct])
}

enum ErrorViewType {
    case networkError
}

final class SearchViewController: UIViewController, SearchView {

    var presenter: SearchPresenter!

    private var collectionView: SearchCollectionView!

    override func viewDidLoad() {
        presenter.loadProducts()
        configureView()
    }

    func showError(type: ErrorViewType) {
        print("ERROR:", type)
    }
    
    func addProducts(products: [PreviewProduct]) {
        collectionView.addItems(products)
    }

    func showCategories(categories: [Category]) {
    }
}

extension SearchViewController {
    private enum Constants {
        static let collectionOffset = 8.0
    }
    func configureCell(model: PreviewProduct, index: Int) {
        let index = IndexPath(row: index, section: 0)
        guard let cell = collectionView.cellForItem(at: index) as? SearchCollectionCell else {
            return
        }
        collectionView.configureCell(cell, with: model, at: index)
    }

    private func configureView() {
        view.backgroundColor = .primaryBackground
        let layout = UICollectionViewFlowLayout()
        let itemSize = (view.frame.width / 2.0) - Constants.collectionOffset * 2 + 4
        layout.itemSize = CGSize(width: itemSize, height: itemSize + 80)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView = SearchCollectionView(layout: layout)
        collectionView.contentInset = .init(
            top: 0,
            left: Constants.collectionOffset,
            bottom: 0,
            right: Constants.collectionOffset
        )
        collectionView.searchDelegate = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .primaryBackground
        
        for subview in [collectionView!] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchViewController: SearchCollectionViewDelegate {
    func didReachEndOfData() {
        presenter?.loadProducts()
    }
}
