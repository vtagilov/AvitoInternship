final class SearchModule: Module {
    var view: SearchViewController
    var interactor: SearchInteractor
    var presenter: SearchPresenterImpl
    var router: SearchRouter

    init(
        view: SearchViewController,
        interactor: SearchInteractor,
        presenter: SearchPresenterImpl,
        router: SearchRouter
    ) {
        self.view = view
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
    }
}

struct SearchModuleContext: Context {
    let networkManager: NetworkManager
    let coreRouter: CoreRouter

    init(appContext: AppContext) {
        self.networkManager = appContext.networkManager
        self.coreRouter = appContext.coreRouter
    }
}

final class SearchModuleFactory: ModuleFactory {
    typealias ViewController = SearchViewController
    typealias ModuleContext = SearchModuleContext

    func makeModule(_ context: SearchModuleContext) -> any Module {
        let view = SearchViewController()
        let interactor = SearchInteractor(networkManager: context.networkManager)
        let presenter = SearchPresenterImpl(interactor: interactor)
        let router = SearchRouter(coreRouter: context.coreRouter, view: view)

        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.router = router
        router.filterDelegate = presenter

        let module = SearchModule(
            view: view,
            interactor: interactor,
            presenter: presenter,
            router: router
        )
        return module
    }
}
