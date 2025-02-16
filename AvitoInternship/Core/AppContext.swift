final class AppContext {
    let networkManager: NetworkManager
    let coreRouter: CoreRouter

    init() {
        self.networkManager = NetworkManager()
        self.coreRouter = CoreRouterImpl()
        coreRouter.appContext = self
    }
}
