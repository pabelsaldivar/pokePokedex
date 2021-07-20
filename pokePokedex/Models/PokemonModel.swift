//
//  PokemonModel.swift
//  pokePokedex
//
//  Created by Jonathan Pabel Saldivar Mendoza on 30/04/21.
//

import Foundation

struct PokemonModel: Codable {
    let id: Int
    let name: String
    let url: String
    let imageName: String
    let isFavorite: Bool
}
