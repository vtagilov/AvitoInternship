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

    init(appContext: AppContext) {
        self.networkManager = appContext.networkManager
    }
}

final class SearchModuleFactory: ModuleFactory {
    typealias ViewController = SearchViewController
    typealias ModuleContext = SearchModuleContext

    func makeModule(_ context: SearchModuleContext) -> any Module {
        let view = SearchViewController()
        let interactor = SearchInteractor(networkManager: context.networkManager)
        let presenter = SearchPresenterImpl(interactor: interactor)
        let router = SearchRouter()

        view.presenter = presenter
        presenter.view = view

        let module = SearchModule(
            view: view,
            interactor: interactor,
            presenter: presenter,
            router: router
        )
        return module
    }
}
