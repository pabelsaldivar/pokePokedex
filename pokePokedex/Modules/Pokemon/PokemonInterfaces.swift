//
//  PokemonInterfaces.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

enum PokemonNavigationOption {
}

protocol PokemonWireframeInterface: WireframeInterface {
    func navigate(to option: PokemonNavigationOption)
}

protocol PokemonViewInterface: ViewInterface {
}

protocol PokemonPresenterInterface: PresenterInterface {
}

protocol PokemonInteractorInterface: InteractorInterface {
}
