import UIKit

protocol CoreRouter: AnyObject {
    func navigateToSearchScreen(appContext: AppContext)
    func navigateBack()
}

final class CoreRouterImpl: CoreRouter {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigateToSearchScreen(appContext: AppContext) {
        let factory = SearchModuleFactory()
        let context = SearchModuleContext(appContext: appContext)
        let module = factory.makeModule(context)
        navigationController?.pushViewController(module.view, animated: true)
    }

    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
