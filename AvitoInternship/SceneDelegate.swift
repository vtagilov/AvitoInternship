import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var coreRouter: CoreRouter?
    private var appContext = AppContext()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        coreRouter = CoreRouterImpl(navigationController: navigationController)
        coreRouter?.navigateToSearchScreen(appContext: appContext)

        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
