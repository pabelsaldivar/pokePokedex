//
//  FavouritesInterfaces.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

enum FavouritesNavigationOption {
    case SignOut
    case detail(pokemon: PokemonModel)
}

protocol FavouritesWireframeInterface: WireframeInterface {
    func navigate(to option: FavouritesNavigationOption)
}

protocol FavouritesViewInterface: ViewInterface {
    func show(_ error:Error)
    func showLoader()
    func hideLoader()
    func favourites(didFinishToFetch pokemons: [PokemonModel])
}

protocol FavouritesPresenterInterface: PresenterInterface {
    func navigate(to option: FavouritesNavigationOption)
    func fetchPokemons()
    func signOut()
}

protocol FavouritesInteractorInterface: InteractorInterface {
    func fetchLocalPokemons(completion: @escaping(_ result: Result<[PokemonModel], Error>) -> Void)
    func signOut(completion: @escaping(_ result: Result<FavouritesNavigationOption, Error>) -> Void)
}
