//
//  DashboardViewController.swift
//  pokePokedex
//
//  Created by Jonathan Pabel Saldivar Mendoza on 30/04/21.
//

import UIKit
import Alamofire
import FirebaseAuth
import CoreData
import NVActivityIndicatorView

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var activityIndicator: NVActivityIndicatorView!
    var dataSource: [PokemonModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchPokemons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonViewController" {
            if let viewController = segue.destination as? PokemonViewController {
                guard let pokemon = sender as? PokemonModel else {return}
                viewController.pokemon = pokemon
                viewController.delegate = self
            }
        }
    }
    
    func configureView() {
        activityIndicator = NVActivityIndicatorView(frame: (self.view.frame), type: .ballRotateChase, color: .white, padding: 80.0)
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(activityIndicator)
    }
    
    func fetchPokemons() {
        self.activityIndicator.startAnimating()
        fetchLocalPokemons { (result) in
            switch result {
            case .success(let pokemons):
                self.dataSource = pokemons
                if self.dataSource.isEmpty {
                    self.fetchPokemonsService { (result) in
                        switch result {
                        case .success(let pokemons):
                            self.dataSource = pokemons
                            self.save(pokemons)
                            self.updateView(isLocalData: false)
                        case .failure(let error):
                            self.show(error)
                        }
                    }
                } else {
                    self.updateView(isLocalData: true)
                }
            case .failure(_ ):
                break
            }
        }
    }
    
    func updateView(isLocalData: Bool = true) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
            self.infoLabel.text = isLocalData ? "Listo!, ahora estamos mostrando los datos consultados de la base de datos local de la app" : " Si deseas ver la misma lista haciendo la consulta de la base de datos local, sal y vuelve a ingresar a esta pantalla"
        }
    }
    
    func fetchPokemonsService(completion: @escaping(_ result: Result<[PokemonModel], Error>) -> Void) {
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
    
    func fetchLocalPokemons(completion: @escaping(_ result: Result<[PokemonModel], Error>) -> Void) {
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
    
    func show(_ error: Error) {
        let title = "Ooh oh! "
        let message = error.localizedDescription
        let settingsActionTitle = "Entendido"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: settingsActionTitle, style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(goToSettings)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        if let _ = try? Auth.auth().signOut() {
            performSegue(withIdentifier: "logout", sender: nil)
        }
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell", for: indexPath) as! PokemonCollectionViewCell
        cell.pokemon = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.collectionView.frame.width / 2) - 32)
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = dataSource[indexPath.row]
        performSegue(withIdentifier: "PokemonViewController", sender: pokemon)
    }
}

extension DashboardViewController: PokemonViewDelegate {
    func pokemonController(didChangefavourite pokemon: PokemonModel) {
        fetchPokemons()
    }
}
