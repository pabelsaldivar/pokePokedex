//
//  DashboardPresenter.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 21/07/21.

import UIKit

final class DashboardPresenter {
    
    // MARK: - Private properties -
    
    private unowned let _view: DashboardViewInterface
    private let _wireframe: DashboardWireframeInterface
    private let _interactor: DashboardInteractorInterface
    
    // MARK: - Lifecycle -
    
    init(wireframe: DashboardWireframeInterface, view: DashboardViewInterface, interactor: DashboardInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension DashboardPresenter: DashboardPresenterInterface {
    func navigate(to option: DashboardNavigationOption) {
        _wireframe.navigate(to: option)
    }
    
    func fetchPokemons() {
        _view.showLoader()
        _interactor.fetchLocalPokemons { (result) in
            switch result {
            case .success(let pokemons):
                if pokemons.isEmpty {
                    self._interactor.fetchPokemonsService { (result) in
                        self._view.hideLoader()
                        switch result {
                        case .success(let remotePokemons):
                            self._interactor.save(remotePokemons)
                            self._view.dashboard(didFinishToFetch: remotePokemons, locally: false)
                        case .failure(let error):
                            self._view.show(error)
                        }
                    }
                } else {
                    self._view.hideLoader()
                    self._view.dashboard(didFinishToFetch: pokemons, locally: true)
                }
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
