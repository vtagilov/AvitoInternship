import UIKit

protocol CoreRouter: AnyObject {
    var navigationController: UINavigationController? { get }
    var appContext: AppContext? { get set }
    func navigateToSearchScreen()
    func navigateToDetailScreen(product: PreviewProduct)
}

final class CoreRouterImpl: CoreRouter {
    var navigationController: UINavigationController?
    weak var appContext: AppContext?

    init() {
        self.navigationController = UINavigationController()
    }

    func navigateToSearchScreen() {
        if let appContext {
            let factory = SearchModuleFactory()
            let context = SearchModuleContext(appContext: appContext)
            let module = factory.makeModule(context)
            navigationController?.pushViewController(module.view, animated: true)
        }
    }
    
    func navigateToDetailScreen(product: PreviewProduct) {
        if let appContext {
            let factory = ProductCardModuleFactory()
            let context = ProductCardModuleContext(appContext: appContext, product: product)
            let module = factory.makeModule(context)
            navigationController?.pushViewController(module.view, animated: true)
        }
    }
    
    func navigateToCartScreen() {
        
    }

    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
