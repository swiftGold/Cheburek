import UIKit

protocol Router {
    func setRoot(_ viewController: UIViewController, isNavigationBarHidden: Bool)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
}

final class AppRouter {
    private let window: UIWindow
    private var navigationController: UINavigationController
    
    init(
        window: UIWindow,
        navigationController: UINavigationController
    ) {
        self.window = window
        self.navigationController = navigationController
    }
}

extension AppRouter: Router {
    func setRoot(_ viewController: UIViewController, isNavigationBarHidden: Bool) {
        navigationController.isNavigationBarHidden = isNavigationBarHidden
        navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }
}
