//
//  PokemonResponseModel.swift
//  pokePokedex
//
//  Created by Jonathan Pabel Saldivar Mendoza on 30/04/21.
//

import Foundation

struct PokemonResponseModel: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonResponseResultModel]
}

struct PokemonResponseResultModel: Codable {
    let name: String
    let url: String
}
