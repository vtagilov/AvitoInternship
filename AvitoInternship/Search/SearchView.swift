import UIKit

protocol SearchView: View {
    func showProducts(products: [ProductDTO])
    func showError(type: ErrorViewType)
}

enum ErrorViewType {
    case networkError
}

final class SearchViewController: UIViewController, SearchView {

    var presenter: SearchPresenter!

    override func viewDidLoad() {
        view.backgroundColor = .systemBlue
        presenter.loadProducts()
    }

    func showProducts(products: [ProductDTO]) {
        print("Products:", products)
    }

    func showError(type: ErrorViewType) {
        print("ERROR:", type)
    }
}
