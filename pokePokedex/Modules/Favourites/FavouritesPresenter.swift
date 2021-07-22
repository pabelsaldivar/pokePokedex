//
//  FavouritesPresenter.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

final class FavouritesPresenter {

    // MARK: - Private properties -

    private unowned let _view: FavouritesViewInterface
    private let _wireframe: FavouritesWireframeInterface
    private let _interactor: FavouritesInteractorInterface

    // MARK: - Lifecycle -

    init(wireframe: FavouritesWireframeInterface, view: FavouritesViewInterface, interactor: FavouritesInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension FavouritesPresenter: FavouritesPresenterInterface {
    func navigate(to option: FavouritesNavigationOption) {
        _wireframe.navigate(to: option)
    }
    
    func fetchPokemons() {
        _view.showLoader()
        _interactor.fetchLocalPokemons { (result) in
            switch result {
            case .success(let pokemons):
                self._view.hideLoader()
                self._view.favourites(didFinishToFetch: pokemons)
            case .failure(let error):
                self._view.hideLoader()
                self._view.show(error)
            }
        }
    }
    
    func signOut() {
        _view.showLoader()
        _interactor.signOut { result in
            self._view.hideLoader()
            switch result {
            case .success(let route):
                self._wireframe.navigate(to: route)
            case .failure(let error):
                self._view.show(error)
            }
        }
    }
}
