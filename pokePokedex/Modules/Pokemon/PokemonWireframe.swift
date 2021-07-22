//
//  PokemonWireframe.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

final class PokemonWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let _storyboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - Module setup -

    init(_ pokemon: PokemonModel, delegate: PokemonViewDelegate) {
        let moduleViewController = _storyboard.instantiateViewController(ofType: PokemonViewController.self)
        super.init(viewController: moduleViewController)
        
        let interactor = PokemonInteractor()
        let presenter = PokemonPresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
        moduleViewController.pokemon = pokemon
        moduleViewController.delegate = delegate
    }
}

// MARK: - Extensions -

extension PokemonWireframe: PokemonWireframeInterface {
    func navigate(to option: PokemonNavigationOption) {
    }
}
