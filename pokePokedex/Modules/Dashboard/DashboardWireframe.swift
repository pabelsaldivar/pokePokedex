//
//  DashboardWireframe.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 21/07/21.

import UIKit

final class DashboardWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let _storyboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = _storyboard.instantiateViewController(ofType: DashboardViewController.self)
        super.init(viewController: moduleViewController)
        
        let interactor = DashboardInteractor()
        let presenter = DashboardPresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension DashboardWireframe: DashboardWireframeInterface {
    func navigate(to option: DashboardNavigationOption) {
        switch option {
        case .SignOut:
            let wireframe = LoginWireframe()
            wireframe.viewController.modalPresentationStyle = .fullScreen
            navigationController?.presentWireframe(wireframe, animated: true)
        case .detail(let pokemon):
            let wireframe = PokemonWireframe(pokemon, delegate: viewController.self as! PokemonViewDelegate)
            navigationController?.presentWireframe(wireframe, animated: true)
        }
    }
}
