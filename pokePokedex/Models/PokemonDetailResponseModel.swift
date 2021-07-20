//
//  PokemonDetailResponseModel.swift
//  pokePokedex
//
//  Created by Jonathan Pabel Saldivar Mendoza on 03/05/21.
//

import Foundation

class PokemonDetailResponseModel: Codable {
    let id: Int
    let name: String
    let base_experience: Int
    let height: Int
    let is_default: Bool
    let order: Int
    let weight: Int
}
