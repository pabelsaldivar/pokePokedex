//
//  LoginWireframe.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

final class LoginWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let _storyboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = _storyboard.instantiateViewController(ofType: LoginViewController.self)
        super.init(viewController: moduleViewController)
        
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension LoginWireframe: LoginWireframeInterface {
    func navigate(to option: LoginNavigationOption) {
        switch option {
        case .Dashboard:
            let tabBar = MainTabViewController()
            tabBar.modalPresentationStyle = .fullScreen
            viewController.present(tabBar, animated: true, completion: nil)
        }
    }
}
