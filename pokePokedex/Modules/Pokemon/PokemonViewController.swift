//
//  PokemonViewController.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit
import Alamofire
import NVActivityIndicatorView
import CoreData

protocol PokemonViewDelegate {
    func pokemonController(didChangefavourite pokemon: PokemonModel)
}

final class PokemonViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: PokemonPresenterInterface!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weighttLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var activityIndicator: NVActivityIndicatorView!
    var pokemon: PokemonModel?
    var dataSource: PokemonDetailResponseModel?
    var delegate: PokemonViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchDetail()
        validateFavoriteState()
    }
    
    func configureView() {
        if let pokemon = pokemon {
            titleLabel.text = pokemon.name.capitalized
            titleImageView.image = UIImage(named: pokemon.imageName)
        }
        
        if let dataSource = dataSource {
            idLabel.text = "pokemon id: \(dataSource.id)"
            heightLabel.text = "Alto: \(dataSource.height)"
            weighttLabel.text = "Peso: \(dataSource.weight)"
        } else {
            idLabel.text = "Cargando..."
            heightLabel.text = ""
            weighttLabel.text = ""
        }
        
        let value = pokemon?.url.split(separator: "/").last
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(value!).png"
        pokemonImageView.downloadedFrom(link: url, contentMode: .scaleAspectFit)
        
        activityIndicator = NVActivityIndicatorView(frame: (self.view.frame), type: .ballRotateChase, color: .white, padding: 80.0)
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(activityIndicator)
    }
    
    func validateFavoriteState() {
        if let pokemon = pokemon {
            favouriteButton.setImage(pokemon.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func fetchDetail() {
        guard let requestURL = pokemon?.url else {return}
        activityIndicator.startAnimating()
        AF.request(requestURL, method: .get, headers: nil)
            .validate()
            .responseDecodable(of:PokemonDetailResponseModel.self) { (response) in
                self.activityIndicator.stopAnimating()
                switch response.result {
                case .success(let pokemonDetail):
                    self.dataSource = pokemonDetail
                    self.configureView()
                case .failure(let error):
                    self.show(error)
                }
            }
    }
    
    func show(_ error: Error) {
        let title = "Ooh oh! "
        let message = error.localizedDescription
        let settingsActionTitle = "Entendido"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: settingsActionTitle, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(goToSettings)
        self.present(alert, animated: true)
    }
    
    func changeFavoritePokemon(by id: Int, completion: (_ result: Result<PokemonModel, Error>) -> Void) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", Int16(id))
        fetchRequest.predicate = predicate
        
        do {
            let pokemonRequest = try context.fetch(fetchRequest)
            if let pokemonObjct = pokemonRequest.first {
                pokemonObjct.isFavorite = !pokemonObjct.isFavorite
                if let _ = try? context.save() {
                    let pokemon = PokemonModel(id: Int(pokemonObjct.id),
                                               name: pokemonObjct.name ?? "",
                                               url: pokemonObjct.url ?? "",
                                               imageName: pokemonObjct.imageName ?? "",
                                               isFavorite: pokemonObjct.isFavorite)
                    completion(.success(pokemon))
                } else {
                    completion(.failure(GenericError.pokemonNotFound))
                }
            } else {
                completion(.failure(GenericError.pokemonNotFound))
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        changeFavoritePokemon(by: pokemon?.id ?? -9090909) { result in
            switch result {
            case .success(let pokemon):
                self.pokemon = pokemon
                validateFavoriteState()
                delegate?.pokemonController(didChangefavourite: pokemon)
            case .failure(_ ):
                print("Error al cambiar el estado")
            }
        }
    }
}

// MARK: - Extensions -

extension PokemonViewController: PokemonViewInterface {
}
