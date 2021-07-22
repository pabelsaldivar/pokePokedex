//
//  FavouritesInteractor.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import Foundation
import Alamofire
import FirebaseAuth
import CoreData

final class FavouritesInteractor {
}

// MARK: - Extensions -

extension FavouritesInteractor: FavouritesInteractorInterface {
    func fetchLocalPokemons(completion: @escaping (Result<[PokemonModel], Error>) -> Void) {
        var pokemonList:[PokemonModel] = []
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite = %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        
        do {
            let pokemonRequest = try context.fetch(fetchRequest)
            for pokemonObjct in pokemonRequest {
                let pokemon = PokemonModel(id: Int(pokemonObjct.id),
                                           name: pokemonObjct.name ?? "",
                                           url: pokemonObjct.url ?? "",
                                           imageName: pokemonObjct.imageName ?? "",
                                           isFavorite: pokemonObjct.isFavorite)
                pokemonList.append(pokemon)
            }
            completion(.success(pokemonList))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func signOut(completion: @escaping (Result<FavouritesNavigationOption, Error>) -> Void) {
        if let _ = try? Auth.auth().signOut() {
            completion(.success(.SignOut))
        } else {
            completion(.failure(GenericError.emptyUser))
        }
    }
}
