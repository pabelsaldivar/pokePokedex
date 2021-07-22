//
//  FavouritesWireframe.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

final class FavouritesWireframe: BaseWireframe {
    
    // MARK: - Private properties -
    
    private let _storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - Module setup -
    
    init() {
        let moduleViewController = _storyboard.instantiateViewController(ofType: FavouritesViewController.self)
        super.init(viewController: moduleViewController)
        
        let interactor = FavouritesInteractor()
        let presenter = FavouritesPresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension FavouritesWireframe: FavouritesWireframeInterface {
    func navigate(to option: FavouritesNavigationOption) {
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
