//
//  PokemonPresenter.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

final class PokemonPresenter {

    // MARK: - Private properties -

    private unowned let _view: PokemonViewInterface
    private let _wireframe: PokemonWireframeInterface
    private let _interactor: PokemonInteractorInterface

    // MARK: - Lifecycle -

    init(wireframe: PokemonWireframeInterface, view: PokemonViewInterface, interactor: PokemonInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension PokemonPresenter: PokemonPresenterInterface {
}
