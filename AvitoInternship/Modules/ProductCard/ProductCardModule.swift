final class ProductCardModule: Module {
    var view: ProductCardViewController
    var interactor: ProductCardInteractor
    var presenter: ProductCardPresenterImpl
    var router: ProductCardRouter

    init(
        view: ProductCardViewController,
        interactor: ProductCardInteractor,
        presenter: ProductCardPresenterImpl,
        router: ProductCardRouter
    ) {
        self.view = view
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
    }
}

struct ProductCardModuleContext: Context {
    let networkManager: NetworkManager
    let product: PreviewProduct

    init(appContext: AppContext, product: PreviewProduct) {
        self.networkManager = appContext.networkManager
        self.product = product
    }
}

final class ProductCardModuleFactory: ModuleFactory {
    typealias ViewController = ProductCardViewController
    typealias ModuleContext = ProductCardModuleContext

    func makeModule(_ context: ProductCardModuleContext) -> any Module {
        let view = ProductCardViewController(previewProduct: context.product)
        let interactor = ProductCardInteractor(networkManager: context.networkManager)
        let presenter = ProductCardPresenterImpl(interactor: interactor, previewProduct: context.product)
        let router = ProductCardRouter(view: view)

        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.router = router

        let module = ProductCardModule(
            view: view,
            interactor: interactor,
            presenter: presenter,
            router: router
        )
        return module
    }
}
