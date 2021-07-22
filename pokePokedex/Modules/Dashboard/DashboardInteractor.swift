//
//  DashboardInteractor.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 21/07/21.

import Foundation
import Alamofire
import FirebaseAuth
import CoreData

final class DashboardInteractor {
}

// MARK: - Extensions -

extension DashboardInteractor: DashboardInteractorInterface {
    func fetchPokemonsService(completion: @escaping (Result<[PokemonModel], Error>) -> Void) {
        let requestURL = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1118"
        AF.request(requestURL, method: .get, headers: nil)
            .validate()
            .response { (response) in
                switch response.result {
                case .success(let data):
                    guard let data = data else {return}
                    let decoder = JSONDecoder()
                    if let serviceData = try? decoder.decode(PokemonResponseModel.self, from: data) {
                        print(serviceData)
                        var pokemons: [PokemonModel] =  []
                        var id = 0
                        for pokemonData in serviceData.results {
                            pokemons.append(PokemonModel(id: id,
                                                         name: pokemonData.name,
                                                         url: pokemonData.url,
                                                         imageName: self.randomImageName(),
                                                         isFavorite: false))
                            id += 1
                        }
                        completion(.success(pokemons))
                    } else {
                        print("No se Obtuvo la información correctamente")
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchLocalPokemons(completion: @escaping (Result<[PokemonModel], Error>) -> Void) {
        var pokemonList:[PokemonModel] = []
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        do {
            let pokemonRequest = try context.fetch(fetchRequest)
            for pokemonObjct in pokemonRequest {
                let pokemon = PokemonModel(id: Int(pokemonObjct.id),
                                           name: pokemonObjct.name ?? "",
                                           url: pokemonObjct.url ?? "",
                                           imageName: pokemonObjct.imageName ?? "",
                                           isFavorite: pokemonObjct.isFavorite)
                if pokemonObjct.isFavorite {
                    print("El Pokemon \(pokemon.name) es favorito")
                }
                pokemonList.append(pokemon)
            }
            completion(.success(pokemonList))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func randomImageName() -> String {
        let randomInt = Int.random(in: 0...2)
        return "pokeball\(randomInt)"
    }
    
    func save(_ pokemons: [PokemonModel]) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let persistanceContainer = appDelegate.persistentContainer
            let context = persistanceContainer.viewContext
            
            let entity =
                NSEntityDescription.entity(forEntityName: "Pokemon",
                                           in: context)!
            
            for pokemonItem in pokemons {
                let pokemon = NSManagedObject(entity: entity,
                                              insertInto: context)
                pokemon.setValue(pokemonItem.id, forKeyPath: "id")
                pokemon.setValue(pokemonItem.name, forKeyPath: "name")
                pokemon.setValue(pokemonItem.url, forKeyPath: "url")
                pokemon.setValue(pokemonItem.imageName, forKeyPath: "imageName")
                pokemon.setValue(pokemonItem.isFavorite, forKeyPath: "isFavorite")
            }
            do {
                try context.save()
            } catch {
                print("Algo salio mal al guardar los datos")
            }
        }
    }
    
    func signOut(completion: @escaping (Result<DashboardNavigationOption, Error>) -> Void) {
        if let _ = try? Auth.auth().signOut() {
            completion(.success(.SignOut))
        } else {
            completion(.failure(GenericError.emptyUser))
        }
    }
    
}
