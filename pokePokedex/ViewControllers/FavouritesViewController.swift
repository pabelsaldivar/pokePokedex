//
//  FavouritesViewController.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 20/07/21.
//

import UIKit
import Alamofire
import FirebaseAuth
import CoreData
import NVActivityIndicatorView

class FavouritesViewController: UIViewController {
    
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
                self.updateView(isLocalData: true)
            case .failure(_ ):
                break
            }
        }
    }
    
    func updateView(isLocalData: Bool = true) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    func randomImageName() -> String {
        let randomInt = Int.random(in: 0...2)
        return "pokeball\(randomInt)"
    }
    
    func fetchLocalPokemons(completion: @escaping(_ result: Result<[PokemonModel], Error>) -> Void) {
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

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension FavouritesViewController: PokemonViewDelegate {
    func pokemonController(didChangefavourite pokemon: PokemonModel) {
        fetchPokemons()
    }
}
