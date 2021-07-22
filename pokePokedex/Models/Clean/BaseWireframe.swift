//
//  BaseWireframe.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.
//

import UIKit

protocol WireframeInterface: class {
}

class BaseWireframe {

    private unowned var _viewController: UIViewController

    //to retain view controller reference upon first access
    private var _temporaryStoredViewController: UIViewController?

    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {

}

extension BaseWireframe {
    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }

    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
    var tabBarController: UITabBarController? {
        return viewController.tabBarController
    }

}

extension UIViewController {
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
    
    func presentWireframeOnNewNavController(_ wireframe: BaseWireframe, animated: Bool = true) {
        let navigationController = UINavigationController(rootViewController: wireframe.viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

extension UINavigationController {
    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.present(wireframe.viewController, animated: true, completion: nil)
    }
    
    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
}


