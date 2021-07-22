//
//  DashboardInterfaces.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 21/07/21.

import UIKit

enum DashboardNavigationOption {
    case SignOut
    case detail(pokemon: PokemonModel)
}

protocol DashboardWireframeInterface: WireframeInterface {
    func navigate(to option: DashboardNavigationOption)
}

protocol DashboardViewInterface: ViewInterface {
    func show(_ error:Error)
    func showLoader()
    func hideLoader()
    func dashboard(didFinishToFetch pokemons: [PokemonModel], locally: Bool)
}

protocol DashboardPresenterInterface: PresenterInterface {
    func navigate(to option: DashboardNavigationOption)
    func fetchPokemons()
    func signOut()
}

protocol DashboardInteractorInterface: InteractorInterface {
    func fetchPokemonsService(completion: @escaping(_ result: Result<[PokemonModel], Error>) -> Void)
    func fetchLocalPokemons(completion: @escaping(_ result: Result<[PokemonModel], Error>) -> Void)
    func randomImageName() -> String
    func save(_ pokemons: [PokemonModel])
    func signOut(completion: @escaping(_ result: Result<DashboardNavigationOption, Error>) -> Void)
}
