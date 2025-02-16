import Foundation

protocol SearchPresenter: Presenter {
    var view: SearchView? { get set }
    var router: SearchRouter? { get set }
    
    func loadProducts(_ title: String?)
    func loadMoreProducts()
    func filterButtonPressed()
    func productSelected(product: PreviewProduct)
}

final class SearchPresenterImpl: SearchPresenter {
    weak var view: SearchView?
    var router: SearchRouter?
    
    private let interactor: SearchInteractor
    
    private var filterContext: FilterContext?
    
    init(interactor: SearchInteractor) {
        self.interactor = interactor
        interactor.fetchCategories()
    }

    func loadProducts(_ title: String?) {
        view?.updateState(.loading)
        Task {
            let result = await interactor.fetchProducts(title: title)
            DispatchQueue.main.async { [weak view] in
                switch result {
                case .failure:
                    view?.updateState(.error(.networkError))
                case .success(let models):
                    if models.isEmpty {
                        view?.updateState(.noResults)
                        return
                    }
                    view?.setProducts(products: models)
                }
            }
        }
    }
    
    func loadMoreProducts() {
        Task {
            let result = await interactor.fetchMoreProducts()
            DispatchQueue.main.async { [weak view] in
                switch result {
                case .failure(let error):
                    if case .alreadyLoading = error { return }
                    view?.updateState(.error(.networkError))
                case .success(let models):
                    view?.addProducts(products: models)
                }
            }
        }
    }
    
    func loadFilteredProducts(_ filter: FilterContext?) {
        view?.updateState(.loading)
        Task {
            let result = await interactor.fetchProductsWithFilters(context: filter)
            DispatchQueue.main.async { [weak view] in
                switch result {
                case .failure:
                    view?.updateState(.error(.networkError))
                case .success(let models):
                    if models.isEmpty {
                        view?.updateState(.noResults)
                        return
                    }
                    view?.setProducts(products: models)
                }
            }
        }
    }
    
    func filterButtonPressed() {
        router?.showFilerBottomSheet(categories: interactor.categories, filters: filterContext)
    }
    
    func productSelected(product: PreviewProduct) {
        router?.showProductCard(product: product)
    }
}

extension SearchPresenterImpl: FilterBottomSheetDelegate {
    func setFilterContext(_ context: FilterContext) {
        filterContext = context
        loadFilteredProducts(context)
    }
}
